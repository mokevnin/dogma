class PathHelper
  class << self
    def yaml_mapping_fixtures
      File.join(DOGMA_SPEC_PATH, '/fixtures/mapping/driver')
    end

    def schema
      DOGMA_SPEC_PATH + '/schema'
    end
  end
end
