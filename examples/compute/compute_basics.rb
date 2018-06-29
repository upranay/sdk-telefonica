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

# Query execution status of tasks
taskStatus = service.query_task_status('job_id')
puts "Task status response :#{taskStatus.body}"

# Display FloatingIP details
floatingIp = service.show_floating_ip('floating_ip')
p "floatingIp is :#{floatingIp.body}"

# Modify ecs specification
ecs_specifiction = service.update_ecs_specifications('server_id', 'flavor_id')
p "Updated ECS speification :#{ecs_specifiction.body}"