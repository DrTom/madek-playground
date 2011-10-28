require 'spec_helper'

describe Mediaresourcegrouppermission do

  it "should be producible by a factory" do
    (FactoryGirl.create :mediaresourcegrouppermission).should_not == nil
  end

  context "because of data consistency (referential integrity)" do

    it "should raise an error if the group is set to null" do
      expect { FactoryGirl.create :mediaresourcegrouppermission , :usergroup_id => nil }.to raise_error
    end
    it "should raise an error if the group_id is set to a non existing group" do
      expect { FactoryGirl.create :mediaresourcegrouppermission , :usergroup_id => -1 }.to raise_error
    end


    it "should raise an error if the mediaresource is set to null" do
      expect { FactoryGirl.create :mediaresourcegrouppermission , :mediaresource_id => nil }.to raise_error
    end
    it "should raise an error if the mediaresource_id is set to a non existing mediaresource" do
      expect { FactoryGirl.create :mediaresourcegrouppermission , :mediaresource_id => -1}.to raise_error
    end



  end

end

