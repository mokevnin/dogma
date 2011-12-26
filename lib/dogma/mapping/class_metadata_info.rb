module Dogma
  module Mapping
    class ClassMetadataInfo
      attr_reader :root_entity_name, :identifier
      def initialize(entity_name)
        @root_entity_name = entity_name
        @identifier = []
        @column_names = {}
        @field_names = {}
        @table = {}
        @field_mappings = {}
      end

      def identifier?(field_name)
        field_name == @identifer[0]
      end

      def has_field?(field_name)
        @field_mappings.has_key?(field_name.to_s)
      end

      def column_name(field_name)
        @column_names[field_name] || field_name
      end

      def identifier=(v)
        @identifier = v
        @identifier_compose = true if @identifier.size > 1
      end

      def table_name=(v)
        @table[:name] = v
      end

      def primary_table=(v)
        if v[:name]
          @table[:name] = v[:name]
        end
      end

      def map_field(mapping)
        #TODO validate
        @field_mappings[mapping[:field_name]] = mapping
      end
    end
  end
end
