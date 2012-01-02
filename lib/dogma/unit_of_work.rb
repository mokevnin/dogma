module Dogma
  class UnitOfWork
    def initialize(em)
      @em = em
      @identity_map = IdentityMap.new(@em)
      @entity_changesets = {}
      @original_entity_data = {}
      @entity_states = {}
      @entity_inserts = {}
      @entity_updates = {}
      @entity_deletions = {}
      @entity_identifers = {}
      @persisters = {}
    end

    def contains?(entity)
      scheduled_for_insert?(entity) ||
        @identity_map.contains?(entity) && !scheduled_for_delete?(entity)
    end

    def remove(entity)
      visited = {}
      do_remove(entity, visited)
    end

    def do_remove(entity, visited = {})
      oid = entity.object_id
      return if visited[oid]

      visited[oid] = entity
      cascade_remove(entity)
      case entity_state(entity)
      when :managed
        schedule_for_delete(entity)
      end

    end

    def cascade_remove(entity)
      metadata = @em.class_metadata(entity.class)
      mappings = metadata.association_mappings.values.select {|m| m[:cascade_remove]}
      mappings.each do |mapping|
        values = Array(metadata.value(entity, mapping[:field_name]))
        values.each do |value|
          do_remove(value)
        end
      end
    end

    def commit
      compute_changesets
      #sorted_classes = commit_order
      #@em.transaction do
        if @entity_inserts.any?
          @entity_inserts.keys.map{|klass| execute_inserts(klass)}
        end

        if @entity_updates.any?
          @entity_updates.keys.map{|klass| execute_updates(klass)}
        end

        if @entity_deletions.any?
          @entity_deletions.keys.map{|klass| execute_deletions(klass)}
        end
      #end

      @entity_inserts = {}
      @entity_updates = {}
      @entity_deletions = {}
      @entity_changesets = {}
      #TODO clean up collections
    end

    def commit_order(entity_changeset = nil)
      if entity_change_set.nil?
        entity_changeset = @entity_inserts + @entity_updates + @entity_deletions
      end
      #TODO

    end

    def compute_changesets
      @entity_inserts.dup.each_pair do |klass, entities|
        metadata = @em.class_metadata(klass)
        entities.values.map {|entity| compute_changeset(entity)}
      end

      @identity_map.each_pair do |klass, items|
        metadata = @em.class_metadata(klass)
        items.values.each do |entity|
          compute_changeset(entity)
        end
      end
    end

    def compute_changeset(entity)
      oid = entity.object_id
      metadata = @em.class_metadata(entity.class)
      actual_data = {}

      metadata.field_names.each do |field_name|
        value = metadata.value(entity, field_name)
        if !metadata.identifier?(field_name)
          actual_data[field_name] = value
        end
      end

      if @original_entity_data[oid]

      else
        @original_entity_data[oid] = actual_data
        changeset = {}
        actual_data.each do |field_name, value|
          if metadata.has_association?(field_name)

          else
            changeset[field_name] = [nil, value]
          end
        end
        @entity_changesets[oid] = changeset
      end

      # associations
      metadata.association_mappings.each do |field_name, mapping|
        value = metadata.value(entity, field_name)
        compute_association_changes(mapping, value) if value.present?
      end
    end

    def compute_association_changes(mapping, value)
      #TODO skip proxy
      #if value.is_a? PersistentCollection

      #end
      unwrapped_value = Array(value)
      unwrapped_value.each do |entity|
        case entity_state(entity)
        when :new
          persist_new(entity)
          compute_changeset(entity)
        else

        end
      end
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

        #cascade_persist(entity, visited)
      end

      #def cascade_persist(entity, visited)
        #metadata = @em.class_metadata(entity.class)
        #metadata.association_mappings.each_pair do |name, mapping|
          #next unless mapping[:cascade_persist]
          #related_entities = metadata.value(entity, name)
          #if related_entities.any?
            #raise related_entities.inspect
          #end
        #end
      #end

      def execute_deletions(klass)
        metadata = @em.class_metadata(klass)
        persister = entity_persister(klass)
        @entity_deletions[klass].values.each do |entity|
          persister.delete(entity)
          #@entity_identifiers.delete(entity.object_id)
          @original_entity_data.delete(entity.object_id)
          @entity_states.delete(entity.object_id)
          @entity_deletions[klass].delete(entity.object_id)
          metadata.set_identifier_values(entity, nil)
        end
      end

      def execute_inserts(klass)
        metadata = @em.class_metadata(klass)
        persister = entity_persister(klass)
        #TODO changeset
        post_insert_ids = persister.batch_insert(@entity_inserts[klass].values)
        post_insert_ids.each_pair do |id, entity|
          metadata.set_identifier_values(entity, id)
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

      def persist_new(entity)
        @entity_states[entity.object_id] = :managed
        schedule_for_insert(entity)
      end

      def schedule_for_delete(entity)
        #TODO check errors
        @entity_deletions[entity.class] ||= {}
        @entity_deletions[entity.class][entity.object_id] = entity
      end

      def schedule_for_insert(entity)
        #TODO check errors
        @entity_inserts[entity.class] ||= {}
        @entity_inserts[entity.class][entity.object_id] = entity
      end
  end

end
