module Dogma
  module Hydration
    class SimpleObject < AbstractHydrator
      def hydrate_all_data(stmt, metadata)
        result = []
        stmt.each do |data|
          result << hydrate_row_data(data, metadata)
        end

        result
      end

      def hydrate_row_data(result, metadata)
        data = {}
        result.each_pair do |column, value|
          mapping = metadata.field_mapping_by_column(column)
          type = mapping[:type]
          data[mapping[:field_name]] = convert_to_type(type, value)
        end

        @em.uof.create_entity(metadata.klass, data)
      end

      #TODO
      def convert_to_type(type, value)
        case type
        when 'integer'
          value.to_i
        else
          value
        end
      end
    end
  end
end
