module Dogma
  class UnitOfWork
    def initialize(em)
      @em = em
      reset
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
      case entity_state(entity)
      when :new
        persist_new(entity)
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
        metadata = @em.class_metadata(klass)
        persister = entity_persister(klass)
        post_insert_ids = persister.batch_insert(@entity_inserts[klass].values)
        post_insert_ids.each_pair do |id, entity|
          entity.instance_variable_set "@#{metadata.identifier[0]}", id
          oid = entity.object_id
          #@entity_identifiers[oid] = id
          @entity_states[oid] = :managed
          add_to_identity_map(entity)
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
        @entity_identifers = {}
        @identity_map = {}
        @persisters = {}
      end

      def add_to_identity_map(entity)

      end

      def persist_new(entity)
        oid = entity.object_id
        @entity_states[oid] = :managed
        @entity_inserts[entity.class] ||= {}
        @entity_inserts[entity.class][oid] = entity
        if @entity_identifers[oid]
          add_to_identity_map(entity)
        end
      end
  end
end
