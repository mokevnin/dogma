module Dogma
  class UnitOfWork
    def initialize(em)
      @em = em
      reset
    end

    def commit
      #TODO order
      @em.transaction do
        if @entity_inserts.any?
          @entity_inserts.keys.map{|klass| execute_inserts(klass)}
        end
        #TODO delete
      end

      reset
    end

    def persist(entity)
      case entity_state(entity)
      when :new
        persist_new
      end
    end

    def entity_state(entity)
      if @entity_states[entity.object_id]
        return @entity_states[entity.object_id]
      end

      metadata = @em.class_metadata(entity.class)
      id = metadata.identifier_values(entity)

      return :new unless id

      :detached
    end

    private
      def execute_inserts(klass)
        persister = entity_persister(klass)
        post_insert_ids = persister.batch_insert(@entity_insertions[klass])
        post_insert_ids.each_with_pair do |id, entity|
          oid = entity.object_id
          @entity_identifiers[oid] = ''
          @entity_states[oid] = :managed
          add_to_identity_map(entity)
        end
      end

      def reset
        @entity_states = {}
        @entity_inserts = {}
        @entity_updates = {}
        @entity_identifers = {}
        @identity_map = {}
      end

      def add_to_identity_map(entity)

      end

      def persist_new(entity)
        oid = entity.object_id
        @entity_states[oid] = :managed
        @entity_insertions[entity.class] ||= {}
        @entity_insertions[entity.class][oid] = entity
        if @entity_identifers[oid]
          add_to_identity_map(entity)
        end
      end
  end
end
