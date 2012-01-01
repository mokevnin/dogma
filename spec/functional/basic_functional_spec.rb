require 'spec_helper'

describe Dogma do
  before do
    DB = Sequel.sqlite
    require PathHelper.schema

    @em = Dogma::EntityManager.new DB
  end

  it 'should be work with one to many association' do
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
    user.add_phonenumber(ph)

    @em.flush

    @em.contains?(user).should be_true
    @em.contains?(ph).should be_true

    user.name = 'new_name'
    @em.flush
  end
end
