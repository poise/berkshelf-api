berkshelf-api
=============

[![Build Status](https://travis-ci.org/poise/berkshelf-api.png?branch=master)](https://travis-ci.org/poise/berkshelf-api)

Quick Start
-----------

Apply the following role to your server (making sure both cookbooks are available):

```json
{
  "name": "berkshelf-api",
  "description": "",
  "json_class": "Chef::Role",
  "default_attributes": {
  },
  "override_attributes": {
  },
  "chef_type": "role",
  "run_list": [
      "recipe[poise-ruby]",
      "recipe[nginx]",
      "recipe[berkshelf-api]",
  ],
  "env_run_lists": {
  }
}
```

poise-ruby is optional; if you have another way of installing ruby, just set node['berkshelf-api']['ruby']['bin_dir'] .


Attributes
----------

* `node['berkshelf-api']['path']` – The directory to hold the configuration and cache. *(default: /etc/berkshelf)*
* `node['berkshelf-api']['version']` – Version or git reference to install. *(default: master)*
* `node['berkshelf-api']['port']` – Port to listen on. *(default: 26200)*
* `node['berkshelf-api']['user']` – User to run as. *(default: berkshelf)*
* `node['berkshelf-api']['group']` – Group to run as. *(default: berkshelf)*
* `node['berkshelf-api']['ruby']['bin_dir']` – Where to find gem, and where to install binaries. *(default: /opt/ruby-210/bin)*
* `node['berkshelf-api']['install_path']` – The directory to clone into if installing from git. *(default: /opt/berkshelf)*
* `node['berkshelf-api']['git_repository']` – URI to clone from if installing from git. *(default: https://github.com/berkshelf/berkshelf-api.git)*
* `node['berkshelf-api']['config']` – A hash of configuration data to be added to config.json. *(default: {})*
* `node['berkshelf-api']['opscode_url']` – URL to use for the default Community Site endpoint. *(default: https://community.opscode.com/api/v1)*
* `node['berkshelf-api']['proxy']['enabled']` – Install an HTTP proxy. *(default: if the apache2 or nginx recipe is in the run list)*
* `node['berkshelf-api']['proxy']['listen_ports']` – HTTP ports for the proxy. *(default: [80])*
* `node['berkshelf-api']['proxy']['hostname']` – Server name for the proxy. *(default: node['fqdn'])*
* `node['berkshelf-api']['proxy']['ssl_enabled']` – Configure HTTPS support. *(default: false)*
* `node['berkshelf-api']['proxy']['ssl_redirect_http']` – Redirect from http: to https: if SSL is enabled. *(default: true)*
* `node['berkshelf-api']['proxy']['ssl_listen_ports']` – HTTPS ports for the proxy. *(default: [443])*
* `node['berkshelf-api']['proxy']['ssl_path']` – Base path for SSL-related files. *(default: /etc/berkshelf/ssl)*
* `node['berkshelf-api']['proxy']['ssl_cert_path']` – Path to the SSL certificate. *(default: /etc/berkshelf/ssl/berkshelf-api.pem)*
* `node['berkshelf-api']['proxy']['ssl_key_path']` – Path to the SSL private key. *(default: /etc/berkshelf/ssl/berkshelf-api.key)*
* `node['berkshelf-api']['proxy']['provider']` – Proxy provider to use. One of: nginx, apache. *(default: auto-detect based on run list)*

Resources
---------

### berkshelf_api

The `berkshelf_api` resource defines a berkshelf-api server installation.

```ruby
berkshelf_api '/etc/berks' do
  version '1.1.0'
  config do
    endpoints [{type: 'opscode'}]
  end
end
```

All resource attributes have the same meaning as the node attributes above and
default to the node attribute if not specified.

* `path` – The directory to hold the configuration and cache. *(name_attribute)*
* `version` – Version or git reference to install. *(default: node['berkshelf-api']['version'])*
* `port` – Port to listen on. *(default: node['berkshelf-api']['port'])*
* `user` – User to run as. *(default: node['berkshelf-api']['user'])*
* `group` – Group to run as. *(default: node['berkshelf-api']['group'])*
* `install_path` – The directory to clone into if installing from git. *(default: node['berkshelf-api']['install_path'])*
* `git_repository` – URI to clone from if installing from git. *(default: node['berkshelf-api']['git_repository'] if version is a git reference)*
* `config` – A hash or block of configuration data to be added to config.json.

### berkshelf_api_opscode_endpoint

The `berkshelf_api_opscode_endpoint` defines a community site endpoint for a
`berkshelf_api` resource.

```ruby
berkshelf_api_opscode_endpoint 'https://community.opscode.com/api/v1'
```

It can also be used via the shorter, nested syntax:

```ruby
berkshelf_api '/etc/berks' do
  opscode_endpoint # Defaults to node['berkshelf-api']['opscode_url'] if no URL is given
  opscode_endpoint 'http://example.com/cookbooks'
end
```

* `url` – URL for the community site. *(name_attribute)*

### berkshelf_api_chef_server_endpoint

The `berkshelf_api_chef_server_endpoint` defines a chef server endpoint for a
`berkshelf_api` resource.

```ruby
berkshelf_api_chef_server_endpoint 'https://api.opscode.com/organizations/example' do
  client_name 'berks'
  client_key <<EOH
-----BEGIN RSA PRIVATE KEY-----
[...]
-----END RSA PRIVATE KEY-----
EOH
end
```

It can also be used via the shorter, nested syntax:

```ruby
berkshelf_api '/etc/berks' do
  chef_server_endpoint 'https://api.opscode.com/organizations/example', 'berks', '[...]'
  chef_server_endpoint 'https://api.opscode.com/organizations/example' do
    client_name 'berks'
    client_key <<EOH
-----BEGIN RSA PRIVATE KEY-----
[...]
-----END RSA PRIVATE KEY-----
EOH
  end
end
```

* `url` – URL for the chef server. *(name_attribute)*
* `client_name` – Chef API client username. *(required)*
* `client_key` – Chef API client private key. *(required)*

### berkshelf_api_auto_chef_server_endpoint

The `berkshelf_api_chef_server_endpoint` defines a chef server endpoint for a
`berkshelf_api` resource that uses the same configuration as the active chef-client.

```ruby
berkshelf_api_auto_chef_server_endpoint ''
```

It can also be used via the shorter, nested syntax:

```ruby
berkshelf_api '/etc/berks' do
  auto_chef_server_endpoint
end
```

### berkshelf_api_github_endpoint

The `berkshelf_api_github_endpoint` defines a Github endpoint for a
`berkshelf_api` resource.

```ruby
berkshelf_api_github_endpoint 'myorg' do
  api_token '[...]'
end
```

It can also be used via the shorter, nested syntax:

```ruby
berkshelf_api '/etc/berks' do
  github_endpoint 'myorg', '[...]'
  github_endpoint 'myorg' do
    api_token '[...]'
  end
end
```

* `organization` – Github organization to scan. *(name_attribute)*
* `api_token` – Github API token. *(required)*
