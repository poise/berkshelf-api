#
# Author:: Noah Kantrowitz <noah@coderanger.net>
#
# Copyright 2013, Balanced, Inc.
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

directory '/etc/berkshelf/ssl' do
  owner 'root'
  group 'root'
  mode '700'
  recursive true
end

file '/etc/berkshelf/ssl/berkshelf-api.pem' do
  owner 'root'
  group 'root'
  mode '600'
  content <<EOH
-----BEGIN CERTIFICATE-----
MIIDxDCCAqygAwIBAgIJAKJ7H/LTOjaVMA0GCSqGSIb3DQEBBQUAMEoxCzAJBgNV
BAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMQ4wDAYDVQQKEwVQb2lzZTEWMBQG
A1UEAxMNYmVya3NoZWxmLWFwaTAeFw0xMzEyMjgwMTI4NTZaFw0xNDAxMjcwMTI4
NTZaMEoxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9ybmlhMQ4wDAYDVQQK
EwVQb2lzZTEWMBQGA1UEAxMNYmVya3NoZWxmLWFwaTCCASIwDQYJKoZIhvcNAQEB
BQADggEPADCCAQoCggEBAMT9IP2lcyB3gvrir+dcYe7Ilr1hkw8K+ZHce+NY4qAt
E/2B0lxsytCGkro6YDznkyztH4R/LAkVc6fjSObzRTqr5nyzVYwOQKFFhUXmoUM2
N4smdG5N8essqnAOy5FXKoXl5exB3P094xgVhTNlgKpluNLHQzSS+FpsEsi6l5Ta
9YU84pUDi/RN+IO+saael2H7iZpydxuuQJffzqplvowJAdkrD3LAM4YGVrSmWY5a
prj2NU/LVXagid+8GfKXV1JNaitNCI0YKBUqDWKH83nCWsG55wdjuvAhWslA9u9Z
Z6RW9f2q8fL6iIUaSz5FpxmMn7aQ0lLbamybZse+Bo8CAwEAAaOBrDCBqTAdBgNV
HQ4EFgQUM2sJkOvUIuGjY1DIqIHXJ07iIdswegYDVR0jBHMwcYAUM2sJkOvUIuGj
Y1DIqIHXJ07iIduhTqRMMEoxCzAJBgNVBAYTAlVTMRMwEQYDVQQIEwpDYWxpZm9y
bmlhMQ4wDAYDVQQKEwVQb2lzZTEWMBQGA1UEAxMNYmVya3NoZWxmLWFwaYIJAKJ7
H/LTOjaVMAwGA1UdEwQFMAMBAf8wDQYJKoZIhvcNAQEFBQADggEBAGMetGUZhuuG
LwwsYiGVBqlqyby4e2hsBDGPA5rfyyPJ+WdRdu+vTuQ1qPva/IXodYvzt1Hx8IE8
RvfUztnFNZ95E1mlcpHGNjBdb6qol3+ma91gut6oVpG/ygVILV4dCRwZRDH3Ekz3
kmhQrMxKZeZUuI2TNZo/OuSaoqM9eGGJ5x4wn9FxtJz//rm1JNdxJaCGaq8zqQI+
N9uqeQ/EUvy/Z8CRBQH8mmvFk0H84+GARsfI/luV3M4DdIdxT3aq9rehWnRjnJXp
GrW3rPCjWvk9NSOg/LLZg0cCWoznRKuNb4q+yHD28nO/v1kEMsnAq+Qyce/eBUJp
tlHo+bHZRf4=
-----END CERTIFICATE-----
EOH
end

file '/etc/berkshelf/ssl/berkshelf-api.key' do
  owner 'root'
  group 'root'
  mode '600'
  content <<EOH
-----BEGIN RSA PRIVATE KEY-----
MIIEpQIBAAKCAQEAxP0g/aVzIHeC+uKv51xh7siWvWGTDwr5kdx741jioC0T/YHS
XGzK0IaSujpgPOeTLO0fhH8sCRVzp+NI5vNFOqvmfLNVjA5AoUWFReahQzY3iyZ0
bk3x6yyqcA7LkVcqheXl7EHc/T3jGBWFM2WAqmW40sdDNJL4WmwSyLqXlNr1hTzi
lQOL9E34g76xpp6XYfuJmnJ3G65Al9/OqmW+jAkB2SsPcsAzhgZWtKZZjlqmuPY1
T8tVdqCJ37wZ8pdXUk1qK00IjRgoFSoNYofzecJawbnnB2O68CFayUD271lnpFb1
/arx8vqIhRpLPkWnGYyftpDSUttqbJtmx74GjwIDAQABAoIBAGObp7n6llt9czLP
u6je0vp+XZLHqyf5Ibd66P5N7NKX2LrgkXGA5ZFJ6xnV+OHzKz2VbdF+yNKTEVd8
m1mE+6WuVK8Ls59NearSz5BIDZVB7hYjzM4WBdUoUcq2AIOusubgGEI+D7PSPmno
P+F8WvJO24Vhkv8brg9zBJCRoaJ3rfVJX+TlTCKBbJ5dAx9iBCEMpsyzk/PFyNKZ
muBcXuQIpi2GFEGH5aJoswifXqTHoi05PnMkzYHOhu8Ch/tZXywbZM3codVTuL19
mHChdVofwRq3VEANAtOpNQxqLeH3aLEf0kRL6zQvp3cmnxXIEDCAWu27JuFuh8H0
YxHzGYECgYEA8LSjMKYiosnoY6ocqPu2MMFbmQbP4KjYA6ap+GT1UzqEQl1DZsuk
pqaJ2ge9GSi6aUg7H8HXepUWFH82rZhMJKapo20Zq2FCJGgAsZpgGB7Knm1uHnNz
A0ImWJL+d8XJChmQC6VQmlSSwxQNQ2ND7CgCiqPo476VHfW6uiyT1cECgYEA0YFi
oSzovGx48nizuG6stKBq+mKAPq6FxPwhVMDoEAlJCCT1J/jcSeb8FfQAZMnZMnDl
woPcmP1N6113WSomCVZ7d8CjbPobC3YsEg9hnfm1bBP1ZQmw5uPM8k0hv3zUcOmR
JWjr8pcFdRhSCV/MiyjogoVBm+6nhE4OsyeDEE8CgYEAs8YF98itJ63q7bzYiPDu
Ir3XHpRy35TbOObaHVWx0EZtD2++bmD8CSdq37dV6Rt9FjLHTbGlsLz2b7qPaNnN
TLZZDmDmghQypSQ0GHF3AazFocuTKhUJuk5Ge3LVsTi8LNnotnnymEFAF4i7WzAh
Q5iiRU+kGax2jJjBrFis1UECgYEAxk913+DVsL3wwnv0iqjge925RacFg8/JOcv7
dPFg+QUBB1+MW7jaNG4bwmAEG2NhX7i0E6qjnoFvR1JizZjzBjXBi3pid55LCU9j
qfi7S0D6NQKzb197/yI0dksCnfJ4WSUNyl6FsUy40r0hslPnFvazGBExKHwAP2Fv
0q+dBUsCgYEAzyij5qDjZECPkj4m020cCIwEKPCzkfhDh72+uCPRnp+O+Ot5gpSU
zFjZWvj/Ckyy468Z5YZe9fJS4kqQHJdTMSBtjXVG2R2gnet7ucA3jg4/5Ms5JQSj
I28R2tN0I0pt2JcYQOpUh/wz0Dmcd1lfqBmxNyT5o+HuFWZXoxlPZso=
-----END RSA PRIVATE KEY-----
EOH
end
