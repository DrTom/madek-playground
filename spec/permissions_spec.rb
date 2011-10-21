require 'spec_helper'

describe "Permissions" do

  describe "A public viewable Mediaresource" do
    mediaresource = FactoryGirl.create :mediaresource, :perm_public_may_view => true, :owner => (FactoryGirl.create :user)

    it "should be viewalbe by an unrelated user" do
      user = FactoryGirl.create :user
      (Permissions.can_view? mediaresource, user).should == true
    end

    it "should be viewable by an user, even when the user is not allowed by user permissions" do
      user = FactoryGirl.create :user
      mediaresourceuserpermission = FactoryGirl.create :mediaresourceuserpermission, :user => user, :mediaresource => mediaresource, :maynot_view => true
      (Permissions.can_view? mediaresource, user).should == true
    end

  end


  describe "A non public viewable Mediaresource" do 

    owner = (FactoryGirl.create :user)
    mediaresource = FactoryGirl.create :mediaresource, :perm_public_may_view => false, :owner => owner 

    it "can be viewed by its owner"  do
      (Permissions.can_view? mediaresource, owner).should == true
    end

    it "can be viewed by its owne even if the owner is disallowed by mediaresourceuserpermissions"  do
      mediaresourceuserpermission =
        FactoryGirl.create :mediaresourceuserpermission, :may_view =>false, :maynot_view => true, :mediaresource => mediaresource, :user => owner
      (Permissions.can_view? mediaresource, owner).should == true
    end

  end


  describe "A non public viewable Mediaresource" do

    it "should not be viewable by an user without any permissions" do
      mediaresource = FactoryGirl.create :mediaresource, :perm_public_may_view => false, :owner => (FactoryGirl.create :user)
      user = FactoryGirl.create :user
      (Permissions.can_view? mediaresource,user).should == false
    end

    it "should be be viewable for an user when specified by a mediaresourceuserpermission" do
      mediaresource = FactoryGirl.create :mediaresource, :perm_public_may_view => false, :owner => (FactoryGirl.create :user)
      user = FactoryGirl.create :user
      mediaresourceuserpermission = FactoryGirl.create :mediaresourceuserpermission, :may_view => true, :user => user, :mediaresource => mediaresource
      (Permissions.can_view? mediaresource,user).should == true
    end

    it "should be be viewable for an user when the user belongs to a mediaresourcegrouppermission with given view rights" do
      mediaresource = FactoryGirl.create :mediaresource, :perm_public_may_view => false, :owner => (FactoryGirl.create :user)
      user = FactoryGirl.create :user
      group = FactoryGirl.create :usergroup
      group.users << user
      mediaresourcegrouppermission = FactoryGirl.create :mediaresourcegrouppermission, :may_view => true, :usergroup => group, :mediaresource => mediaresource
      (Permissions.can_view? mediaresource, user).should == true
    end


    it %Q"should not be viewable for an user if the user belongs to a mediaresourcegrouppermission with given view permission 
      but is denied to view through a mediaresourceuserpermission" do
      #binding.pry
      mediaresource = FactoryGirl.create :mediaresource, :perm_public_may_view => false, :owner => (FactoryGirl.create :user)
      user = FactoryGirl.create :user
      group = FactoryGirl.create :usergroup
      group.users << user
      mediaresourcegrouppermission = 
        FactoryGirl.create :mediaresourcegrouppermission, :may_view => true, :usergroup => group, :mediaresource => mediaresource
      mediaresourceuserpermission = 
        FactoryGirl.create :mediaresourceuserpermission, :may_view =>false, :maynot_view => true, :mediaresource => mediaresource, :user => user
      #binding.pry
      (Permissions.can_view? mediaresource,user).should == false
    end

  end

end
