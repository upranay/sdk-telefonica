module Sdk
  module Compute
    class Telefonica
      class Real
        def show_floating_ip(floating_ip, parameters =nil)
          request(
            :expects => [200],
            :method  => 'GET',
            :path    => "os-floating-ips/#{floating_ip}",
            :query   => parameters
          )
        end # def show_floating_ip
      end # class Real

      class Mock
        def show_floating_ip(_floating_ip, _parameters = nil)
          true
        end # def show_floating_ip
      end # class Mock
    end # class Telefonica
  end # module Compute
end # module Sdk
