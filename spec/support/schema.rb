class SchemaBuilder
  def self.run(db)
    db.create_table :cms_users, :force => true do
      primary_key :id
      String :name
      String :username
      String :status
    end

    db.create_table :cms_phonenumbers, :force => true do
      primary_key :id
      String :phonenumber
      String :user_id
    end
  end
end
