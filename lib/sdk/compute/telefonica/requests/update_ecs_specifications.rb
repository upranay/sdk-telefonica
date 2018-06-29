module Sdk
  module Compute
    class Telefonica
      class Real
        def update_ecs_specifications(server_id, flavorRef)
          body = {'resize' => {'flavorRef' => flavorRef}}
          request(
            :body    => Fog::JSON.encode(body),
            :expects => [200],
            :method  => 'POST',
            :path    => "cloudservers/#{server_id}/resize",
            :version => 'v1'
          )
        end
      end

      class Mock
        def update_ecs_specifications(_server_id, _flavorRef)
          response = Excon::Response.new
          response.status = 202
          response
        end
      end
    end
  end
end