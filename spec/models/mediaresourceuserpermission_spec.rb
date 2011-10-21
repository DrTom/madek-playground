require 'spec_helper'

describe Mediaresourceuserpermission do

  it "should be producible by a factory" do
    FactoryGirl.create :user
    FactoryGirl.create :mediaresource
    (FactoryGirl.create :mediaresourceuserpermission).should_not == nil
  end

  context "consistency constraints " do
    u = FactoryGirl.create :user
    mr = FactoryGirl.create :mediaresource, :owner => (FactoryGirl.create :user)

    it "should remove mediaresourceuserpermission if the user is destroyed" do
      id = (FactoryGirl.create :mediaresourceuserpermission, :user => u, :mediaresource => mr).id
      (Mediaresourceuserpermission.find_by_id id).should_not be_nil
      u.destroy
      (Mediaresourceuserpermission.find_by_id id).should be_nil
    end

    it "should remove mediaresourceuserpermission if the mediaresource is destroyed" do
      id = (FactoryGirl.create :mediaresourceuserpermission, :user => u, :mediaresource => mr).id
      (Mediaresourceuserpermission.find_by_id id).should_not be_nil
      mr.destroy
      (Mediaresourceuserpermission.find_by_id id).should be_nil
    end

  end

end
