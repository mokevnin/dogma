require 'spec_helper'

describe Dogma do
  before do
    @em = Dogma::EntityManager.new DbHelper.db
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
    ph.id.should be

    ph2 = Cms::Phonenumber.new
    ph2.phonenumber = '54321'
    user.add_phonenumber(ph2)

    @em.flush

    @em.contains?(ph2).should be_true
    ph2.id.should be
  end
end
