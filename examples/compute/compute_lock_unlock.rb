gem 'sdk-telefonica'

require 'pp'
require 'rubygems'
require 'sdk/telefonica'

auth_url = 'authentication-url'
username = 'username'
password = 'password'

service  = Sdk::Compute::Telefonica.new({ :telefonica_auth_url => auth_url,
                                          :telefonica_api_key  => password,
                                          :telefonica_username => username,
                                          :telefonica_domain_name => 'domain-name',
                                          :telefonica_project_name   => 'project-name',
                                          :telefonica_region => 'region-id'
                                        })

# Lock server
lock_response = service.lock_server('server_id');
puts lock_response.body
puts "Lock server successfully"

# Unlock servers
unlock_response = service.unlock_server('server_id');
puts unlock_response.body
puts "Unlock server successfully"
