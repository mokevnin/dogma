module Dogma
  module Persisters
    class BasicEntity
      def initialize(em, metadata)
        @em = em
        @metadata = metadata
      end

      def batch_insert(entites)
        entities.each do |entity|

        end
      end
    end
  end
end
