module Dogma
  module Mapping
    class ClassMetadata < ClassMetadataInfo
      def identifier_values(entity)
        #TODO compose keys
        entity.instance_variable_get "@#{identifier[0]}"
      end
    end
  end
end
