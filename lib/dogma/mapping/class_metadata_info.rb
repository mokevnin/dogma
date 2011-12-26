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
        field_name.to_s == @identifier[0]
      end

      def has_field?(field_name)
        @field_mappings.has_key?(field_name.to_s)
      end

      def table_name
        @table[:name]
      end

      def column_name(field_name)
        @column_names[field_name] || field_name
      end

      def field_names
        @column_names.keys
      end

      def identifier=(v)
        @identifier = v
        @identifier_compose = true if @identifier.size > 1
      end

      def table_name=(v)
        @table[:name] = v.to_sym
      end

      def map_field(mapping)
        if mapping[:id]
          self.identifier = Array(mapping[:field_name])
        end

        @column_names[mapping[:field_name]] = mapping[:column_name]
        @field_mappings[mapping[:field_name]] = mapping
      end
    end
  end
end
