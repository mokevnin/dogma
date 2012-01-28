require 'spec_helper'

describe Dogma do
  before do
    @em = Dogma::EntityManager.new DbHelper.db
  end

  describe 'one to many association' do
    it 'should be work' do
      user = Cms::User.new
      user.name = 'Roman'
      user.username = 'romand'
      user.status = 'developer'

      ph = Cms::Phonenumber.new
      ph.phonenumber = 'first'
      user.add_phonenumber(ph)

      @em.persist(user)

      ph = Cms::Phonenumber.new
      ph.phonenumber = 'second'
      user.add_phonenumber(ph)

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

      @em.uof.entity_state(user).should eql(:managed)
      @em.uof.entity_state(ph).should eql(:managed)

      @em.remove(user)
      @em.flush

      @em.uof.entity_state(user).should eql(:new)
      @em.uof.entity_state(ph).should eql(:new)
    end

    it 'should be work for modification' do

      user = Cms::User.new
      user.name = 'name'

      ph1 = Cms::Phonenumber.new
      user.add_phonenumber(ph1)

      ph2 = Cms::Phonenumber.new
      ph2.phonenumber = 'second'
      user.add_phonenumber(ph2)

      @em.persist(user)
      @em.flush

      ph2.phonenumber = 'second_changed'
      user.remove_phonenumber(ph1)

      @em.flush

      user2 = @em.repository(Cms::User).find user.id
      user2.object_id.should == user.object_id

      @em.clear

      user2 = @em.repository(Cms::User).find user.id
      user2.id.should == user.id
      user2.object_id.should_not be eql(user.object_id)

    end
  end
end
