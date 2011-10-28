require 'spec_helper'

describe Collectionuserpermission do

  it "should be producible by a factory" do
    (FactoryGirl.create :collectionuserpermission).should_not == nil
  end

  context "consistency constraints " do
    u = FactoryGirl.create :user
    mr = FactoryGirl.create :collection, :owner => (FactoryGirl.create :user)

    it "should remove collectionuserpermission if the user is destroyed" do
      id = (FactoryGirl.create :collectionuserpermission, :user => u, :collection => mr).id
      (Collectionuserpermission.find_by_id id).should_not be_nil
      u.destroy
      (Collectionuserpermission.find_by_id id).should be_nil
    end

    it "should remove collectionuserpermission if the collection is destroyed" do
      id = (FactoryGirl.create :collectionuserpermission, :user => u, :collection => mr).id
      (Collectionuserpermission.find_by_id id).should_not be_nil
      mr.destroy
      (Collectionuserpermission.find_by_id id).should be_nil
    end

  end

end
