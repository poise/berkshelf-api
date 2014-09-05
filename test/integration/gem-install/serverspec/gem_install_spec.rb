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

require 'json'
require 'net/http'
require 'uri'

require 'serverspec'
include Serverspec::Helper::Exec
include Serverspec::Helper::DetectOS

describe port(26200) do
  it { should be_listening }
end

describe port(80) do
  it { should_not be_listening }
end

describe port(443) do
  it { should_not be_listening }
end

describe user('berkshelf') do
  it do
    should exist
    should belong_to_group('berkshelf')
    should have_home_directory('/etc/berkshelf')
  end
end

describe file('/etc/berkshelf/config.json') do
  it { should be_file }
  its(:content) { should match(/"type":"supermarket"/) }
end

describe file('/opt/berkshelf') do
  it { should_not be_directory }
end

describe 'Berkshelf API' do
  it 'should return status ok' do
    pending 'A new release with the status endpoint'
    data = JSON::parse(Net::HTTP.get(URI('http://localhost:26200/status')))
    data['status'].should eq('ok')
  end
end
