#
# Author:: Noah Kantrowitz <noah@coderanger.net>
#
# Copyright 2013-2014, Noah Kantrowitz
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

class Chef
  class Resource::BerkshelfApi < Resource
    include Poise(container: true)
    actions(:install, :uninstall)

    attribute(:path, name_attribute: true)
    attribute(:version, kind_of: String, default: lazy { node['berkshelf-api']['version'] })
    attribute(:port, kind_of: [String, Integer], default: lazy { node['berkshelf-api']['port'] })
    attribute(:user, kind_of: String, default: lazy { node['berkshelf-api']['user'] })
    attribute(:group, kind_of: String, default: lazy { node['berkshelf-api']['group'] })
    attribute(:install_path, kind_of: String, default: lazy { node['berkshelf-api']['install_path'] })
    attribute(:log_path, kind_of: String, default: lazy { node['berkshelf-api']['log_path'] } )
    attribute(:log_verbosity, kind_of: String, equal_to: ['', '-d', '-v', '-q'], default: lazy { node['berkshelf-api']['log_verbosity'] })
    attribute(:git_repository, kind_of: [String, FalseClass], default: lazy { version.match(/^\d+(\.\d+(\.\d+)?)?$/) ? false : node['berkshelf-api']['git_repository'] })
    attribute(:config, option_collector: true)

    def config_path
      ::File.join(path, 'config.json')
    end

    def binary_path
      if git_repository
        ::File.join(install_path, 'vendor', 'bin', 'berks-api')
      else
        'berks-api'
      end
    end

    # Helpers to configure endpoints
    def opscode_endpoint(url = node['berkshelf-api']['opscode_url'], &block)
      berkshelf_api_opscode_endpoint url do
        url url
        instance_exec(&block) if block
      end
    end

    def chef_server_endpoint(url, client_name=nil, client_key=nil, &block)
      berkshelf_api_chef_server_endpoint url do
        url url
        client_name client_name
        client_key client_key
        instance_exec(&block) if block
      end
    end

    def github_endpoint(organization, access_token=nil, &block)
      berkshelf_api_github_endpoint organization do
        organization organization
        access_token access_token
        instance_exec(&block) if block
      end
    end

    def auto_chef_server_endpoint(&block)
      berkshelf_api_auto_chef_server_endpoint '' do
        instance_exec(&block) if block
      end
    end

    def proxy(&block)
      berkshelf_api_proxy '' do
        instance_exec(&block) if block
      end
    end
  end

  class Provider::BerkshelfApi < Provider
    include Poise

    def action_install
      converge_by("install a Berkshelf API server at #{new_resource.path}") do
        notifying_block do
          create_group
          create_user
          install_ruby
          create_home_dir
          install_libarchive
          install_berkshelf_api
          create_config
          install_service
        end
      end
    end

    def action_uninstall
      converge_by("uninstall a Berkshelf API server at #{new_resource.path}") do
        notifying_block do
          remove_user
          remove_group
        end
      end
    end

    private

    def create_group
      group new_resource.group do
        system true
      end
    end

    def create_user
      user new_resource.user do
        comment "Berkshelf API service user for #{new_resource.path}"
        gid new_resource.group
        system true
        shell '/bin/false'
        home new_resource.path
      end
    end

    def install_ruby
      include_recipe 'build-essential' # GCC needed for mutli-json gem et al
      poise_ruby 'ruby-210'
    end

    def create_home_dir
      directory new_resource.path do
        owner new_resource.user
        group new_resource.group
        mode '755'
      end
    end

    def install_libarchive
      if node.platform_family?('rhel')
        package 'libarchive'
        package 'libarchive-devel'
      elsif node.platform_family?('debian', 'ubuntu')
        package 'libarchive12'
        package 'libarchive-dev'
      else
        raise "Unknown platform family #{node['platform_family']}, please update #install_libarchive"
      end
    end

    def install_berkshelf_api
      if new_resource.git_repository
        install_from_git
      else
        install_from_gems
      end
    end

    def install_from_gems
      gem_package 'berkshelf-api' do
        gem_binary '/opt/ruby-210/bin/gem'
        options '--bindir /opt/ruby-210/bin'
        version new_resource.version
      end
    end

    def install_from_git
      include_recipe 'git'

      directory new_resource.install_path do
        owner 'root'
        group 'root'
        mode '755'
      end

      git new_resource.install_path do
        repository new_resource.git_repository
        revision new_resource.version
      end

      gem_package 'bundler' do
        gem_binary '/opt/ruby-210/bin/gem'
        options '--bindir /opt/ruby-210/bin'
        action :upgrade
      end

      # For use in the only_if below
      r = new_resource
      execute 'berks-api-bundle-install' do
        cwd new_resource.install_path
        command "/opt/ruby-210/bin/bundle install --binstubs=vendor/bin --without development test"
        environment 'PATH' => "/opt/ruby-210/bin:#{ENV['PATH']}"
        only_if do
          gemfile = ::File.join(r.install_path, 'Gemfile')
          gemfile_lock = ::File.join(r.install_path, 'Gemfile.lock')
          !::File.exists?(gemfile_lock) || ::File.mtime(gemfile) > ::File.mtime(gemfile_lock)
        end
      end
    end

    def create_config
      config = Mash.new(endpoints: [])
      new_resource.subresources.each do |res|
        if res.is_a?(Resource::BerkshelfApiEndpoint) && res.action == :enable
          config[:endpoints] << res.endpoint_data
        end
      end
      config.update(node['berkshelf-api']['config'])
      config.update(new_resource.config)

      file new_resource.config_path do
        owner 'root' # Don't give berks-api write access to its own config
        group new_resource.group
        mode '640'
        content JSONCompat.to_json_pretty(config)
      end
    end

    def service_resource
      include_recipe 'runit'

      if !@service_resource
        subcontext_block do
          @service_resource = runit_service 'berkshelf-api' do
            action :enable
            options new_resource: new_resource
            cookbook 'berkshelf-api'
            sv_timeout 600 # It can be slow while the cache is loading
          end
        end
      end
      @service_resource
    end

    def install_service
      run_context.resource_collection << service_resource
    end

    def remove_group
      r = create_group
      r.action(:remove)
      r
    end

    def remove_user
      r = create_user
      r.action(:remove)
      r
    end

  end
end
