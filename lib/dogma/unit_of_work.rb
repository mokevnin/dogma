module Dogma
  class UnitOfWork
    def initialize(em)
      @em = em
      @identity_map = IdentityMap.new(@em)

      reset
    end

    def contains?(entity)
      scheduled_for_insert?(entity) \
      || @identity_map.contains?(entity) \
      && !scheduled_for_delete?(entity)
    end

    def commit
      #TODO order
      #@em.transaction do
        if @entity_inserts.any?
          @entity_inserts.keys.map{|klass| execute_inserts(klass)}
        end
        #TODO delete
      #end

      reset
    end

    def persist(entity)
      do_persist(entity)
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

    def scheduled_for_insert?(entity)
      (@entity_inserts[entity.class] || {}).has_key? entity.object_id
    end

    def scheduled_for_update?(entity)
      (@entity_updates[entity.class] || {}).has_key? entity.object_id
    end

    def scheduled_for_delete?(entity)
      (@entity_deletions[entity.class] || {}).has_key? entity.object_id
    end

    private

      def do_persist(entity, visited = {})
        return if visited[entity.object_id]
        visited[entity.object_id] = entity

        case entity_state(entity)
        when :new
          persist_new(entity)
        end

        #TODO cascade persist
      end

      def execute_inserts(klass)
        metadata = @em.class_metadata(klass)
        persister = entity_persister(klass)
        post_insert_ids = persister.batch_insert(@entity_inserts[klass].values)
        post_insert_ids.each_pair do |id, entity|
          entity.instance_variable_set "@#{metadata.identifier[0]}", id
          oid = entity.object_id
          #@entity_identifiers[oid] = id
          @entity_states[oid] = :managed
          @identity_map.add(entity)
        end
      end

      def entity_persister(klass)
        metadata = @em.class_metadata(klass)
        unless @persisters[klass]
          @persisters[klass] = Dogma::Persister::BasicEntity.new(@em, metadata)
        end

        @persisters[klass]
      end

      def reset
        @entity_states = {}
        @entity_inserts = {}
        @entity_updates = {}
        @entity_deletions = {}
        @entity_identifers = {}
        @persisters = {}
      end

      def persist_new(entity)
        @entity_states[entity.object_id] = :managed
        schedule_for_insert(entity)
      end

      def schedule_for_insert(entity)
        #TODO check errors
        @entity_inserts[entity.class] ||= {}
        @entity_inserts[entity.class][entity.object_id] = entity
      end
  end

end
