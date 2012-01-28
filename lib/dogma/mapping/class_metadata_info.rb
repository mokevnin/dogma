module Dogma
  module Mapping
    class ClassMetadataInfo
      attr_reader :root_entity_name, :identifier, :association_mappings
      def initialize(entity_name)
        @root_entity_name = entity_name
        @identifier = []
        @column_names = {}
        @field_names = {}
        @table = {}
        @field_mappings = {}
        @association_mappings = {}
      end

      def klass
        root_entity_name.camelize.constantize
      end

      def identifier?(field_name)
        field_name.to_s == @identifier[0]
      end

      def has_field?(field_name)
        @field_mappings.has_key?(field_name)
      end

      def has_association?(field_name)
        @association_mappings.has_key?(field_name)
      end

      def table_name
        @table[:name]
      end

      def column_name(field_name)
        @column_names[field_name]
      end

      def field_mapping_by_column(column_name)
        @field_mappings[@field_names[column_name.to_s].to_sym]
      end

      def field_names
        @column_names.keys
      end

      def identifier=(v)
        @identifier = v
        @identifier_compose = true if @identifier.size > 1
      end

      def table_name=(v)
        @table[:name] = v ? v.to_sym : root_entity_name.gsub('/', '_').tableize
      end

      def map_one_to_many(mapping)
        mapping[:type] = :one_to_many
        store_association_mapping(mapping)
      end

      def map_field(mapping)
        if mapping[:id]
          self.identifier = Array(mapping[:field_name])
        end

        mapping[:column_name] ||= mapping[:field_name]
        @column_names[mapping[:field_name].to_sym] = mapping[:column_name].to_sym
        @field_names[mapping[:column_name]] = mapping[:field_name]
        @field_mappings[mapping[:field_name].to_sym] = mapping
      end

      private
      def store_association_mapping(mapping)
        mapping[:cascade] ||= []
        mapping[:cascade].each do |type|
          mapping["cascade_#{type}".to_sym] = true
        end
        @association_mappings[mapping[:field_name].to_sym] = mapping
      end
    end
  end
end
