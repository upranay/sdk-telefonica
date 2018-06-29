module Sdk
  module Compute
    class Telefonica
      module MetaParent
        def parent
          @parent
        end

        def parent=(new_parent)
          @parent = new_parent
        end

        def collection_name
          if @parent.class == Sdk::Compute::Telefonica::Image
            return "images"
          elsif @parent.class == Sdk::Compute::Telefonica::Server
            return "servers"
          else
            raise "Metadata is not supported for this model type."
          end
        end

        def metas_to_hash(metas)
          hash = {}
          metas.each { |meta| hash.store(meta.key, meta.value) }
          hash
        end
      end
    end
  end
end
