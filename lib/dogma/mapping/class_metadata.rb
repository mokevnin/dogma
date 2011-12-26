module Dogma
  module Mapping
    class ClassMetadata < ClassMetadataInfo
      def identifier_values(entity)
        raise identifier.inspect
        value = entity.instance_variable_get "@#{identifier[0]}"
      end
    end
  end
end
