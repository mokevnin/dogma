class DbHelper
  class << self
    def db
      db = Sequel.sqlite
      SchemaBuilder.run(db)
      db
    end
  end
end
