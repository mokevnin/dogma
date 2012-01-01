DB.create_table :cms_users, :force => true do
  primary_key :id
  String :name
  String :username
  String :status
end

DB.create_table :cms_phonenumbers, :force => true do
  primary_key :id
  String :phonenumber
  String :user_id
end
