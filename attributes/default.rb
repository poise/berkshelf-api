# -*- coding: utf-8 -*-
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

default['berkshelf-api']['path'] = '/etc/berkshelf'
default['berkshelf-api']['install_path'] = '/opt/berkshelf' # For git installs
default['berkshelf-api']['version'] = 'master'
default['berkshelf-api']['port'] = 26200
default['berkshelf-api']['user'] = 'berkshelf'
default['berkshelf-api']['group'] = 'berkshelf'
default['berkshelf-api']['git_repository'] = 'https://github.com/berkshelf/berkshelf-api.git'
default['berkshelf-api']['ruby_version'] = '2.0.0-p353'
default['berkshelf-api']['config'] = {}
default['berkshelf-api']['opscode_url'] = 'http://community.opscode.com/api/v1'

default['berkshelf-api']['ruby']['bin_dir'] = '/opt/ruby-210/bin'

default['berkshelf-api']['proxy']['enabled'] = !!Chef::Resource::BerkshelfApiProxy.default_provider(node)
default['berkshelf-api']['proxy']['listen_ports'] = [80]
default['berkshelf-api']['proxy']['hostname'] = nil # node['fqdn']
default['berkshelf-api']['proxy']['ssl_enabled'] = false
default['berkshelf-api']['proxy']['ssl_redirect_http'] = true
default['berkshelf-api']['proxy']['ssl_listen_ports'] = [443]
default['berkshelf-api']['proxy']['ssl_path'] = nil # node['berkshelf-api']['path']}/ssl
default['berkshelf-api']['proxy']['ssl_cert_path'] = nil # node['berkshelf-api']['proxy']['ssl_path']/berkshelf-api.pem
default['berkshelf-api']['proxy']['ssl_key_path'] = nil # node['berkshelf-api']['proxy']['ssl_path']/berkshelf-api.key
default['berkshelf-api']['proxy']['provider'] = nil # Auto-detects based on available cookbooks

# ಠ_ಠ ಠ_ಠ ಠ_ಠ ಠ_ಠ ಠ_ಠ
override['apache']['default_site_enabled'] = false
override['nginx']['default_site_enabled'] = false
