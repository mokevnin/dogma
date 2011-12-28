require 'set'

module Dogma
  class IdentityMap
    def initialize(em)
      @em = em
      @maps = {}
    end

    def add(entity)
      #TODO duplicate error

      @maps[entity.class] ||= {}
      @maps[entity.class][id_hash(entity)] = entity
    end

    def contains?(entity)
      @maps[entity.class].has_key? id_hash(entity)
    end

    private

      def id_hash(entity)
        metadata = @em.class_metadata(entity.class)
        id_hash = metadata.identifier_values(entity)
      end
  end
end
