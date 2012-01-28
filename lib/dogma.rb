require 'active_support/core_ext/hash'
require 'active_support/inflector'

module Dogma
  autoload :Version, 'dogma/version'
  autoload :EntityManager, 'dogma/entity_manager'
  autoload :IdentityMap, 'dogma/identity_map'
  autoload :UnitOfWork, 'dogma/unit_of_work'
  autoload :EntityRepository, 'dogma/entity_repository'
  autoload :Configuration, 'dogma/configuration'

  module Persister
    autoload :BasicEntity, 'dogma/persister/basic_entity'
  end

  module Hydration
    autoload :AbstractHydrator, 'dogma/hydration/abstract_hydrator'
    autoload :SimpleObject, 'dogma/hydration/simple_object'
  end

  module Mapping
    module Driver
      autoload :AbstractFile, 'dogma/mapping/driver/abstract_file'
      autoload :Yaml, 'dogma/mapping/driver/yaml'
    end

    autoload :ClassMetadata, 'dogma/mapping/class_metadata'
    autoload :ClassMetadataInfo, 'dogma/mapping/class_metadata_info'
  end

  def self.configure(&block)
    @config = Dogma::Configuration.new &block
  end
  def self.config
    @config
  end
end
