module Sdk
  module Compute
    class Telefonica < Fog::Service
      SUPPORTED_VERSIONS = /v2\.0|v2\.1/
      SUPPORTED_MICROVERSION = '2.15'.freeze

      requires :telefonica_auth_url
      recognizes :telefonica_auth_token, :telefonica_management_url,
                 :persistent, :telefonica_service_type, :telefonica_service_name,
                 :telefonica_tenant, :telefonica_tenant_id,
                 :telefonica_api_key, :telefonica_username, :telefonica_identity_endpoint,
                 :current_user, :current_tenant, :telefonica_region,
                 :telefonica_endpoint_type, :telefonica_cache_ttl,
                 :telefonica_project_name, :telefonica_project_id,
                 :telefonica_project_domain, :telefonica_user_domain, :telefonica_domain_name,
                 :telefonica_project_domain_id, :telefonica_user_domain_id, :telefonica_domain_id,
                 :telefonica_identity_prefix

      ## REQUESTS
      #
      request_path 'sdk/compute/telefonica/requests'

      # Server Actions
      request :start_servers_in_batches
      request :restart_servers_in_batches
      request :stop_servers_in_batches
      request :lock_server
      request :unlock_server

      # Floating Ip
      request :show_floating_ip

      #Querying the Task Status
      request :query_task_status

      #Modifying the Specifications of an ECS
      request :update_ecs_specifications

      class Mock
        attr_reader :auth_token
        attr_reader :auth_token_expiration
        attr_reader :current_user
        attr_reader :current_tenant

        def self.data
          @data ||= Hash.new do |hash, key|
            hash[key] = {
              :last_modified             => {
                :images          => {},
                :servers         => {},
                :key_pairs       => {},
                :security_groups => {},
                # :addresses       => {}
              },
              :aggregates                => [{
                "availability_zone" => "nova",
                "created_at"        => "2012-11-16T06:22:23.032493",
                "deleted"           => false,
                "deleted_at"        => nil,
                "id"                => 1,
                "name"              => "name",
                "updated_at"        => nil
              }],
              :images                    => {
                "0e09fbd6-43c5-448a-83e9-0d3d05f9747e" => {
                  "id"       => "0e09fbd6-43c5-448a-83e9-0d3d05f9747e",
                  "name"     => "cirros-0.3.0-x86_64-blank",
                  'progress' => 100,
                  'status'   => "ACTIVE",
                  'updated'  => "",
                  'minRam'   => 0,
                  'minDisk'  => 0,
                  'metadata' => {},
                  'links'    => [{"href" => "http://nova1:8774/v1.1/admin/images/1", "rel" => "self"},
                                 {"href" => "http://nova1:8774/admin/images/2", "rel" => "bookmark"}]
                }
              },
              :servers                   => {},
              :key_pairs                 => {},
              :security_groups           => {
                '0' => {
                  "id"          => 0,
                  "tenant_id"   => Fog::Mock.random_hex(8),
                  "name"        => "default",
                  "description" => "default",
                  "rules"       => [
                    {"id"              => 0,
                     "parent_group_id" => 0,
                     "from_port"       => 68,
                     "to_port"         => 68,
                     "ip_protocol"     => "udp",
                     "ip_range"        => {"cidr" => "0.0.0.0/0"},
                     "group"           => {}},
                  ],
                },
              },
              :server_groups             => {},
              :server_security_group_map => {},
              # :addresses                 => {},
              :quota                     => {
                'security_group_rules'        => 20,
                'security_groups'             => 10,
                'injected_file_content_bytes' => 10240,
                'injected_file_path_bytes'    => 256,
                'injected_files'              => 5,
                'metadata_items'              => 128,
                'floating_ips'                => 10,
                'instances'                   => 10,
                'key_pairs'                   => 10,
                'gigabytes'                   => 5000,
                'volumes'                     => 10,
                'cores'                       => 20,
                'ram'                         => 51200
              },
              :volumes                   => {},
              :snapshots                 => {},
              :os_interfaces             => [
                {
                  "fixed_ips" => [
                    {
                      "ip_address" => "192.168.1.3",
                      "subnet_id" => "f8a6e8f8-c2ec-497c-9f23-da9616de54ef"
                    }
                  ],
                  "mac_addr" => "fa:16:3e:4c:2c:30",
                  "net_id" => "3cb9bc59-5699-4588-a4b1-b87f96708bc6",
                  "port_id" => "ce531f90-199f-48c0-816c-13e38010b442",
                  "port_state" => "ACTIVE"
                }
              ]
            }  
          end
        end

        def self.reset
          @data = nil
        end

        include Sdk::Telefonica::Core

        def initialize(options = {})
          @auth_token = Fog::Mock.random_base64(64)
          @auth_token_expiration = (Time.now.utc + 86400).iso8601

          initialize_identity options

          management_url = URI.parse(options[:telefonica_auth_url])
          management_url.port = 8774
          management_url.path = '/v1.1/1'
          @telefonica_management_url = management_url.to_s

          identity_public_endpoint = URI.parse(options[:telefonica_auth_url])
          identity_public_endpoint.port = 5000
          @telefonica_identity_public_endpoint = identity_public_endpoint.to_s
        end

        def data
          self.class.data["#{@telefonica_username}-#{@current_tenant}"]
        end

        def reset_data
          self.class.data.delete("#{@telefonica_username}-#{@current_tenant}")
        end
      end

      class Real
        include Sdk::Telefonica::Core

        def self.not_found_class
          Sdk::Compute::Telefonica::NotFound
        end

        def initialize(options = {})
          @supported_versions = SUPPORTED_VERSIONS
          @supported_microversion = SUPPORTED_MICROVERSION
          @microversion_key = 'X-Telefonica-Nova-API-Version'

          initialize_identity options

          @telefonica_identity_service_type = options[:telefonica_identity_service_type] || 'identity'

          @telefonica_service_type   = options[:telefonica_service_type] || %w(nova compute)
          @telefonica_service_name   = options[:telefonica_service_name]

          @connection_options       = options[:connection_options] || {}

          authenticate

          unless @path =~ %r{/(v2|v2\.0|v2\.1)}
            raise Sdk::Telefonica::Errors::ServiceUnavailable,
                  "Telefonica compute binding only supports version v2 and v2.1"
          end

          @persistent = options[:persistent] || false

          @connection = Fog::Core::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
        end
      end
    end
  end
end
