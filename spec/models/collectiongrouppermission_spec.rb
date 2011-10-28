require 'spec_helper'

describe Collectiongrouppermission do
  it "should be producible by a factory" do
    (FactoryGirl.create :collectiongrouppermission).should_not == nil
  end

  context "because of data consistency (referential integrity)" do

    it "should raise an error if the group is set to null" do
      expect { FactoryGirl.create :collectiongrouppermission , :usergroup_id => nil }.to raise_error
    end
    it "should raise an error if the group_id is set to a non existing group" do
      expect { FactoryGirl.create :collectiongrouppermission , :usergroup_id => -1 }.to raise_error
    end


    it "should raise an error if the mediaresource is set to null" do
      expect { FactoryGirl.create :collectiongrouppermission , :collection_id => nil }.to raise_error
    end
    it "should raise an error if the mediaresource_id is set to a non existing mediaresource" do
      expect { FactoryGirl.create :collectiongrouppermission , :collection_id => -1}.to raise_error
    end



  end


end
