module Dogma
  module Persister
    class BasicEntity
      def initialize(em, metadata)
        @em = em
        @conn = @em.connection
        @metadata = metadata
      end

      def delete(entity)
        #TODO cascade remove
        @conn[@metadata.table_name]. \
          filter(@metadata.identifier => @metadata.identifier_values(entity)).delete
      end

      def batch_insert(entities)
        ids = {}
        entities.map do |entity|
          #TODO user changesets
          data = prepare_insert_data(entity)
          id = @conn[@metadata.table_name].insert data
          ids[id] = entity
        end

        ids
      end

      def load(id)
        stmt = @conn[@metadata.table_name]#.filter(@metadata.identifier => id)
        hydrator = @em.new_hydrator
        entities = hydrator.hydrate_all(stmt, @metadata)

        entities ? entities.first : nil
      end

      private

        def prepare_insert_data(entity)
          data = {}
          @metadata.field_names.each do |field|
            data[@metadata.column_name(field)] = @metadata.value(entity, field)
          end

          data
        end
    end
  end
end
