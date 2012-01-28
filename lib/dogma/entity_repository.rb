module Dogma
  class EntityRepository
    def initialize(em, metadata)
      @_em = em
      @_metadata = metadata
    end

    def find(id)
      if entity = @_em.identity_map.get(id, @_metadata.klass)
        return entity
      end
      @_em.uof.entity_persister(@_metadata.root_entity_name).load(id)
    end
  end
end
