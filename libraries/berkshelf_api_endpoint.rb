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

require 'uri'

require File.expand_path('../berkshelf_api', __FILE__)

class Chef
  class Resource::BerkshelfApiEndpoint < Resource
    include Poise(BerkshelfApi)
    actions(:enable, :disable)

    def endpoint_data
      raise NotImplementedError, 'Subclasses must implement #endpoint_data'
    end
  end


  class Resource::BerkshelfApiOpscodeEndpoint < Resource::BerkshelfApiEndpoint
    attribute(:url, name_attribute: true)

    def endpoint_data
      {
        type: 'opscode',
        options: {
          url: url,
        },
      }
    end
  end

  class Resource::BerkshelfApiChefServerEndpoint < Resource::BerkshelfApiEndpoint
    attribute(:url, name_attribute: true)
    attribute(:client_name, kind_of: String, required: true)
    attribute(:client_key, kind_of: String, required: true)
    attribute(:client_key_path, kind_of: String, default: lazy { default_client_key_path })
    attribute(:ssl_verify, equal_to: [true, false], default: true)

    def default_client_key_path
      uri = URI.parse(url)
      key_file = "%s_%s_%s.pem" % [ uri.scheme, uri.host, uri.port ]
      ::File.join(parent.path, key_file)
    end

    def endpoint_data
      {
        type: 'chef_server',
        options: {
          url: url,
          client_name: client_name,
          client_key: client_key_path,
          ssl_verify: ssl_verify,
        },
      }
    end
  end

  class Resource::BerkshelfApiGithubEndpoint < Resource::BerkshelfApiEndpoint
    attribute(:organization, name_attribute: true)
    attribute(:access_token, kind_of: String, required: true)
    attribute(:ssl_verify, equal_to: [true, false], default: true)


    def endpoint_data
      {
        type: 'github',
        options: {
          organization: organization,
          access_token: access_token,
          ssl_verify: ssl_verify,
        },
      }
    end
  end

  class Resource::BerkshelfApiFileStoreEndpoint < Resource::BerkshelfApiEndpoint
    attribute(:path, name_attribute: true)

    def endpoint_data
      {
        type: 'file_store',
        options: {
          path: path,
        },
      }
    end
  end

  class Resource::BerkshelfApiAutoChefServerEndpoint < Resource::BerkshelfApiEndpoint
    attribute(:ssl_verify, equal_to: [true, false], default: true)

    def endpoint_data
      {
        type: 'chef_server',
        options: {
          url: Chef::Config[:chef_server_url],
          client_name: node.name,
          client_key: Chef::Config[:client_key],
          ssl_verify: ssl_verify,
        },
      }
    end
  end

  class Provider::BerkshelfApiEndpoint < Provider
    include Poise

    # Data capsule resource, so provider is a no-op
    def action_enable
    end

    def action_disable
    end
  end

  class Provider::BerkshelfApiOpscodeEndpoint < Provider::BerkshelfApiEndpoint
  end

  class Provider::BerkshelfApiChefServerEndpoint < Provider::BerkshelfApiEndpoint
    def action_enable
      converge_by("install key for #{new_resource.client_name} at #{new_resource.client_key_path}") do
        notifying_block do
          file new_resource.client_key_path do
            owner new_resource.parent.user
            group new_resource.parent.group
            mode '600'
            content new_resource.client_key
            sensitive true
            notifies :restart, new_resource.parent
          end
        end
      end
    end

    def action_disable
      converge_by("remove key for #{new_resource.client_name} from #{new_resource.client_key_path}") do
        notifying_block do
          r = action_enable
          r.action(:remove)
          r
        end
      end
    end
  end

  class Provider::BerkshelfApiGithubEndpoint < Provider::BerkshelfApiEndpoint
  end

  class Provider::BerkshelfApiFileStoreEndpoint < Provider::BerkshelfApiEndpoint
  end

  class Provider::BerkshelfApiAutoChefServerEndpoint < Provider::BerkshelfApiEndpoint
  end
end
