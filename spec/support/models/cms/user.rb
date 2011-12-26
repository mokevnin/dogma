module Cms
  class User
    attr_reader :id
    attr_accessor :status, :username, :name, :phonenumbers, :articles, :address,
      :email, :group

    def initialize()
      @phonenumbers = []
      @articles = []
      @groups = []
    end
  end
end
