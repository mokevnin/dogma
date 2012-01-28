module Dogma
  module Hydration
    class AbstractHydrator
      def initialize(em)
        @em = em
      end

      def iterate(stmt)
        #TODO
      end

      def prepare
        #TODO
      end

      def hydrate_all(stmt, metadata)
        prepare
        result = hydrate_all_data(stmt, metadata)
        #TODO close cursore

        result
      end

    end
  end
end
