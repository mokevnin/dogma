DOGMA_ROOT_PATH = File.join(File.dirname(__FILE__), '..')

def require_dogma_file(part)
  require File.join(DOGMA_ROOT_PATH, '/lib/dogma', part)
end

require 'active_support/core_ext/hash'
require 'active_support/inflector'

require "dogma/version"
require 'dogma/entity_manager'
require 'dogma/unit_of_work'
require 'dogma/mapping/class_metadata_info'
require 'dogma/mapping/class_metadata'
require 'dogma/entity_repository'
require 'dogma/configuration'

#TODO load only if need
require 'dogma/mapping/driver/yaml'

module Dogma
  def self.configure(&block)
    @config = Dogma::Configuration.new &block
  end
  def self.config
    @config
  end
end
