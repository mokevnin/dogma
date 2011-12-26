module Dogma
  module Mapping
    module Driver
      class AbstractFile
        def initialize(paths)
          @paths = Array(paths)
        end

        def elements(name)
          name = name.to_s
          @paths.each do |path|
            file_name = File.join(path, "#{name}.#{self.class::EXTENSION}")
            if File.exist?(file_name)
              element = load_mapping_file(file_name)
              unless element[name]
                raise __LINE__.inspect
              end
              return element[name]
            end
          end

          raise __LINE__.inspect
        end

        def load_mapping_file(file_name)
          #TODO raise
        end
      end
    end
  end
end
