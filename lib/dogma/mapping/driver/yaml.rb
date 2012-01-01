require 'yaml'

module Dogma
  module Mapping
    module Driver
      class Yaml < AbstractFile
        EXTENSION = 'yml'

        def load_metadata_for_class(metadata)
          element = elements(metadata.root_entity_name)

          if element['type'] == 'entity'

          end

          metadata.table_name = element['table']

          if element['id']
            element['id'].each_pair do |name, item|
              mapping = {:id => true, :field_name => name}
              mapping[:type] = item['type']
              mapping[:column_name] = item['column']
              metadata.map_field(mapping)
            end
          end

          if element['fields']
            element['fields'].each_pair do |name, item|
              mapping = {:field_name => name}

              mapping[:type] = item['type']
              mapping[:column_name] = item['column']
              mapping[:length] = item['length']

              metadata.map_field(mapping)
            end
          end

          if element['one_to_many']
            element['one_to_many'].each_pair do |name, item|
              mapping = {:field_name => name,
                :target_entity => item['target_entity'],
                :mapped_by => item['mapped_by']
              }
              mapping[:cascade] = item['cascade']
              mapping[:order_by] = item['order_by']

              metadata.map_one_to_many(mapping)
            end
          end
        end

        private

        def load_mapping_file(file_path)
          YAML.load_file(file_path)
        end
      end
    end
  end
end
