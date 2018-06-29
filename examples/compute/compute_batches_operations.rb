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

# Stop servers in batches
stop_response = service.start_servers_in_batches(['server_id1', 'server_id2'], 'SOFT'); #([server_id1,server_id2,.....server_idn], SOFT/HARD)
puts stop_response.body
puts "Stop server successfully"

# Start servers in batches
start_response = service.start_servers_in_batches(['server_id1', 'server_id2'], 'HARD'); #([server_id1,server_id2,.....server_idn], SOFT/HARD)
puts start_response.body
puts "Start server successfully"

# Restart servers in batches
restart_response = service.restart_servers_in_batches(['server_id1','server_id2'], 'SOFT'); #([server_id1,server_id2,.....server_idn], SOFT/HARD)
puts restart_response.body
puts "Restart server successfully"