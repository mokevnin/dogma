module Dogma
  module Persister
    class BasicEntity
      def initialize(em, metadata)
        @em = em
        @conn = @em.connection
        @metadata = metadata
      end

      def batch_insert(entities)
        ids = {}
        entities.map do |entity|
          data = prepare_insert_data(entity)
          id = @conn[@metadata.table_name].insert data
          ids[id] = entity
        end

        ids
      end

      private

        def prepare_insert_data(entity)
          data = {}
          @metadata.field_names.each do |field|
            data[@metadata.column_name(field)] = entity.instance_variable_get "@#{field}"
          end

          data
        end
    end
  end
end
