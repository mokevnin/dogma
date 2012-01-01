module Dogma
  module Mapping
    class ClassMetadata < ClassMetadataInfo
      def identifier_values(entity)
        #TODO compose keys
        entity.instance_variable_get "@#{identifier[0]}"
      end

      def set_identifier_values(entity, values)
        #TODO compose keys
        entity.instance_variable_set "@#{identifier[0]}", values
      end

      def set_value(entity, field_name, value)
        entity.instance_variable_set "@#{field_name}", value
      end

      def value(entity, field_name)
        entity.instance_variable_get "@#{field_name}"
      end
    end
  end
end
