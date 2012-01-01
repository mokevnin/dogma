require 'spec_helper'

#TODO this test for all drivers
describe Dogma::Mapping::Driver::Yaml do
  before do
   driver = Dogma::Mapping::Driver::Yaml.new PathHelper.yaml_mapping_fixtures
   @metadata = Dogma::Mapping::ClassMetadataInfo.new(:user)
   driver.load_metadata_for_class(@metadata)
  end

  it 'should be build metadata' do
    @metadata.identifier?(:id).should be_true
    @metadata.has_field?(:username).should be_true
    @metadata.has_field?(:wrong_field_name).should be_false

    @metadata.column_name(:username).should eql(:username)
    @metadata.has_association?(:phonenumbers).should be_true
    @metadata.association_mappings[:phonenumbers][:cascade_persist].should be
  end
end
