module Sdk
  module Identity
    class Telefonica < Fog::Service
      requires :telefonica_auth_url
      recognizes :telefonica_auth_token, :telefonica_management_url, :persistent,
                 :telefonica_service_type, :telefonica_service_name, :telefonica_tenant,
                 :telefonica_endpoint_type, :telefonica_region, :telefonica_domain_id,
                 :telefonica_project_name, :telefonica_domain_name,
                 :telefonica_user_domain, :telefonica_project_domain,
                 :telefonica_user_domain_id, :telefonica_project_domain_id,
                 :telefonica_api_key, :telefonica_current_user_id, :telefonica_userid, :telefonica_username,
                 :current_user, :current_user_id, :current_tenant, :telefonica_cache_ttl,
                 :provider, :telefonica_identity_prefix, :telefonica_endpoint_path_matches

      # Sdk::Identity::Telefonica.new() will return a Sdk::Identity::Telefonica::V3 by default
      def self.new(args = {})
        version = '3'
        url = Fog.credentials[:telefonica_auth_url] || args[:telefonica_auth_url]
        if url
          uri = URI(url)
          version = '2.0' if uri.path =~ /v2\.0/
        end

        service = case version
                  when '2.0'
                    Sdk::Identity::Telefonica::V2.new(args)
                  else
                    Sdk::Identity::Telefonica::V3.new(args)
                  end
        service
      end

      class Mock
        attr_reader :config

        def initialize(options = {})
          @telefonica_auth_uri = URI.parse(options[:telefonica_auth_url])
          @config = options
        end
      end

      class Real
        include Sdk::Telefonica::Core

        DEFAULT_SERVICE_TYPE_V3 = %w(identity_v3 identityv3 identity).collect(&:freeze).freeze
        DEFAULT_SERVICE_TYPE    = %w(identity).collect(&:freeze).freeze

        def self.not_found_class
          Sdk::Identity::Telefonica::NotFound
        end

        def initialize(options = {})
          if options.respond_to?(:config_service?) && options.config_service?
            configure(options)
            return
          end

          initialize_identity(options)

          @telefonica_service_type   = options[:telefonica_service_type] || default_service_type(options)
          @telefonica_service_name   = options[:telefonica_service_name]

          @connection_options       = options[:connection_options] || {}

          @telefonica_endpoint_type  = options[:telefonica_endpoint_type] || 'adminURL'
          initialize_endpoint_path_matches(options)

          authenticate

          if options[:telefonica_identity_prefix]
            @path = "/#{options[:telefonica_identity_prefix]}/#{@path}"
          end

          @persistent = options[:persistent] || false
          @connection = Fog::Core::Connection.new("#{@scheme}://#{@host}:#{@port}", @persistent, @connection_options)
        end

        def config_service?
          true
        end

        def config
          self
        end

        private

        def default_service_type(options)
          unless options[:telefonica_identity_prefix]
            if @telefonica_auth_uri.path =~ %r{/v3} ||
               (options[:telefonica_endpoint_path_matches] && options[:telefonica_endpoint_path_matches] =~ '/v3')
              return DEFAULT_SERVICE_TYPE_V3
            end
          end
          DEFAULT_SERVICE_TYPE
        end

        def initialize_endpoint_path_matches(options)
          if options[:telefonica_endpoint_path_matches]
            @telefonica_endpoint_path_matches = options[:telefonica_endpoint_path_matches]
          end
        end

        def configure(source)
          source.instance_variables.each do |v|
            instance_variable_set(v, source.instance_variable_get(v))
          end
        end
      end
    end
  end
end
