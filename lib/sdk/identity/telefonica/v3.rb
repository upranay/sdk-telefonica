require 'sdk/identity/telefonica'

module Sdk
  module Identity
    class Telefonica
      class V3 < Fog::Service
        requires :telefonica_auth_url
        recognizes :telefonica_auth_token, :telefonica_management_url, :persistent,
                   :telefonica_service_type, :telefonica_service_name, :telefonica_tenant,
                   :telefonica_endpoint_type, :telefonica_region, :telefonica_domain_id,
                   :telefonica_project_name, :telefonica_domain_name,
                   :telefonica_user_domain, :telefonica_project_domain,
                   :telefonica_user_domain_id, :telefonica_project_domain_id,
                   :telefonica_api_key, :telefonica_current_user_id, :telefonica_userid, :telefonica_username,
                   :current_user, :current_user_id, :current_tenant,
                   :provider, :telefonica_identity_prefix, :telefonica_endpoint_path_matches, :telefonica_cache_ttl

        class Mock
          include Sdk::Telefonica::Core
          def initialize(options = {})
          end
        end

        def self.get_api_version(uri, connection_options = {})
          connection = Fog::Core::Connection.new(uri, false, connection_options)
          response = connection.request(:expects => [200],
                                        :headers => {'Content-Type' => 'application/json',
                                                     'Accept'       => 'application/json'},
                                        :method  => 'GET')

          body = Fog::JSON.decode(response.body)
          version = nil
          unless body['version'].empty?
            version = body['version']['id']
          end
          if version.nil?
            raise Sdk::Telefonica::Errors::ServiceUnavailable, "No version available at #{uri}"
          end

          version
        end

        class Real < Sdk::Identity::Telefonica::Real
          private

          def default_service_type(_)
            DEFAULT_SERVICE_TYPE_V3
          end

          def initialize_endpoint_path_matches(options)
            if options[:telefonica_endpoint_path_matches]
              @telefonica_endpoint_path_matches = options[:telefonica_endpoint_path_matches]
            else
              @telefonica_endpoint_path_matches = %r{/v3} unless options[:telefonica_identity_prefix]
            end
          end
        end
      end
    end
  end
end
