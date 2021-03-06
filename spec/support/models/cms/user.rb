module Cms
  class User
    attr_reader :id, :phonenumbers
    attr_accessor :status, :username, :name, :articles, :address,
      :email, :group

    def initialize()
      @phonenumbers = []
      @articles = []
      @groups = []
    end

    def add_phonenumber(ph)
      @phonenumbers << ph
      ph.user = self
    end
  end
end
