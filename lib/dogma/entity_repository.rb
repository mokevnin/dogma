module Dogma
  class EntityRepository
    def initialize(em, metadata)
      @_em = em
      @_metadata = metadata
    end

    def find(id)
      if entity = @_em.unit_of_work.try_get_by_id(id, @_metadata.root_entity_name)
        return entity
      end
      @_em.entity_persister(@_metadata.entity_name).load(id)
    end
  end
end
