require 'spec_helper'

describe Dogma do
  before do
    DB = Sequel.sqlite
    require PathHelper.schema

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
    @em.contains?(user).should be_true

    ph = Cms::Phonenumber.new
    ph.phonenumber = '12345'
    user.phonenumber = ph
    @em.flush

    @em.contains?(ph)
    @em.contains?(user)
  end
end
