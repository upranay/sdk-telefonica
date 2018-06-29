module Sdk
  module Compute
    class Telefonica
      class Real
        def restart_servers_in_batches(servers=[], type = 'SOFT')
          servers_id=[]
          servers.each { |item|
            servers_id << {"id" => item}
          }

          body = {'reboot' => {'type' => type,
                                'servers' => servers_id
          }}

          request(
              :body    => Fog::JSON.encode(body),
              :expects => [200, 202],
              :method  => 'POST',
              :path    => "cloudservers/action",
              :version => 'v1'
          )
        end # def restart_servers_in_batches
      end # class Real

      class Mock
        def restart_servers_in_batches(_servers=[], _type = 'SOFT')
          true
        end # def restart_servers_in_batches
      end # class Mock
    end # class Telefonica
  end # module Compute
end # module Sdk
