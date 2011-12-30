module Dogma
  class PersistentCollection
    include Enumerable

    def initialize(em, metadata, collection)
      @em = em
      @metadata = metadata
      @collection = collection

      @snapshot = []
      @fetched = false
      @dirty = false
    end

    def each(&block)
      fetch
      @collection.each &block
    end

    def <<(member)
      @collection << member
      changed
    end

    def fetch
      return if @fetched

      new_objects = dirty? ? @collection : []
      @collection = []
      @em.unit_of_work.load_collection(self)
      @em.take_snapshot

      if new_objects.any?
        @collection += new_objects
        @dirty = true
      end

      @loaded = true
    end

    def take_snapshot
      @snapshot = @collection.dup
    end

    def changed
      return if dirty?
      @dirty = true
      #TODO many to many check
    end

    def dirty?
      @dirty
    end
  end
end
