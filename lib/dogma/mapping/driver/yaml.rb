require 'yaml'

require_dogma_file 'mapping/driver/abstract_file'

module Dogma
  module Mapping
    module Driver
      class Yaml < AbstractFile
        EXTENSION = 'yml'

        def load_metadata_for_class(metadata)
          element = elements(metadata.root_entity_name)

          if element['type'] == 'entity'

          end

          table = {}
          table[:name] = element['table']
          metadata.primary_table = table

          if element['id']
            element['id'].each_pair do |name, item|
              mapping = {:id => true, :field_name => name}
              mapping[:type] = item['type'] if item['type']
              mapping[:column_name] = item['column'] if item['column']
              metadata.map_field(mapping)
            end
          end

          if element['fields']
            element['fields'].each_pair do |name, item|
              mapping = {:field_name => name}

              mapping[:type] = item['type'] if item['type']
              mapping[:column_name] = item['column'] if item['column']
              mapping[:length] = item['length'] if item['length']

              metadata.map_field(mapping)
            end
          end

          true
        end

        private

        def load_mapping_file(file_path)
          YAML.load_file(file_path)
        end
      end
    end
  end
end
