module Sdk
  module Compute
    class Telefonica
      class Real
        def unlock_server(server_id)

          body = {'unlock' => 'null'}

          request(
              :body    => Fog::JSON.encode(body),
              :expects => [200, 202],
              :method  => 'POST',
              :path    => "servers/#{server_id}/action"
          )
        end # def stop_servers_in_batches
      end # class Real

      class Mock
        def unlock_server(_server_id)
          true
        end # def start_server_in_batches
      end # class Mock
    end # class Telefonica
  end # module Compute
end # module Sdk