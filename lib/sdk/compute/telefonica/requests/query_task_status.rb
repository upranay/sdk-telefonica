module Sdk
  module Compute
    class Telefonica
      class Real
        def query_task_status(job_id, parameters = nil)
          request(
            :expects => [200],
            :method  => 'GET',
            :path    => "jobs/#{job_id}",
            :query   => parameters,
            :version => 'v1'
          )
        end # def query_task_status
      end # class Real

      class Mock
        def query_task_status(_job_id, _parameters = nil)
          true
        end # def query_task_status
      end # class Mock
    end # class Telefonica
  end # module Compute
end # module Sdk
