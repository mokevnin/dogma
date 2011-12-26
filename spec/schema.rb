DB.create_table :cms_users, :force => true do
  primary_key :id
  String :name
  String :username
  String :status
end
