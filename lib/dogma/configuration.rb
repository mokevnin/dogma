module Dogma
  class Configuration
    attr_accessor :mapping_paths

    def initialize
      self.mapping_paths = []
      yield self if block_given?
    end
  end
end
