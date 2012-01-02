require 'spec_helper'

describe Dogma::UnitOfWork do
  before do
    @em = Dogma::EntityManager.new DbHelper.db
  end

  describe 'remove' do
    it 'should be work with one to many association' do
      user = Cms::User.new
      @em.persist(user)

      ph = Cms::Phonenumber.new
      ph.phonenumber = '12345'
      user.add_phonenumber(ph)

      @em.flush

      @em.uof.entity_state(user).should eql(:managed)
      @em.uof.entity_state(ph).should eql(:managed)

      @em.remove(user)
      @em.flush

      @em.uof.entity_state(user).should eql(:new)
      @em.uof.entity_state(ph).should eql(:new)
    end
  end
end

