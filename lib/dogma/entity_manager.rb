module Dogma
  class EntityManager
    def initialize(conn)
      @conn = conn
      @unit_of_work = UnitOfWork.new self
      @closed = false
      @repositories = {}
    end

    def repository(klass)
      unless @repositories[klass]
        #TODO loader
        #repo_class = "#{root_entity_name.camelize}Repository"
        repo_class = Dogma::EntityRepository
        metadata = class_metadata(klass)
        @repositories[klass] = repo_class.new(self, metadata)
      end

      @repositories[klass]
    end

    def uof
      @unit_of_work
    end

    def identity_map
      uof.identity_map
    end

    def new_hydrator
      Hydration::SimpleObject.new self
    end

    def persist(entity)
      @unit_of_work.persist(entity)
    end

    def flush
      @unit_of_work.commit
    end

    def remove(entity)
      @unit_of_work.remove(entity)
    end

    def refresh(entity)
      @unit_of_work.refresh(entity)
    end

    def clear
      @unit_of_work.clear
    end

    def contains?(entity)
      @unit_of_work.contains?(entity)
    end

    def connection
      @conn
    end

    def class_metadata(klass)
      driver = Mapping::Driver::Yaml.new(Dogma.config.mapping_paths) #TODO
      metadata = Mapping::ClassMetadata.new(klass.to_s.underscore)
      driver.load_metadata_for_class(metadata)

      metadata
    end

    def close
      clear
      @closed = true
    end
  end
end
