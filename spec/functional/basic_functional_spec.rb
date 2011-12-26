require 'spec_helper'

describe Dogma do
  before do
    DB = Sequel.sqlite
    require DOGMA_ROOT_PATH + '/spec/schema'

    @em = Dogma::EntityManager.new DB
  end

  it 'should be create' do
    user = Cms::User.new
    user.name = 'Roman'
    user.username = 'romand'
    user.status = 'developer'
    @em.persist(user)
    @em.flush

    user.id.should be
    @em.contains(user).should be_true
  end
end
