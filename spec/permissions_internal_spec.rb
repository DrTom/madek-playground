require 'spec_helper'

describe Permissions do

  context "function userpermissionset_disallows" do
    it "should return true if there is a userpermissionset that disallows" do
      user = FactoryGirl.create :user
      mediaresource = FactoryGirl.create :mediaresource
      userpermissionset = FactoryGirl.create :userpermissionset, :user => user, :mediaresource => mediaresource, :maynot_view => true
      (Permissions.userpermissionset_disallows :view, mediaresource, user).should == true
    end
    it "should return false if there is no a userpermissionset that disallows" do
      user = FactoryGirl.create :user
      mediaresource = FactoryGirl.create :mediaresource
      (Permissions.userpermissionset_disallows :view, mediaresource, user).should == false
    end
  end

  context "function userpermissionset_allows" do
    it "should return true if there is a userpermissionset that allows" do
      user = FactoryGirl.create :user
      mediaresource = FactoryGirl.create :mediaresource
      userpermissionset = FactoryGirl.create :userpermissionset, :user => user, :mediaresource => mediaresource, :may_view => true
      (Permissions.userpermissionset_allows :view, mediaresource, user).should == true
    end
    it "should return false if there is no a userpermissionset that allows" do
      user = FactoryGirl.create :user
      mediaresource = FactoryGirl.create :mediaresource
      (Permissions.userpermissionset_allows :view, mediaresource, user).should == false
    end
  end

  context "fucntion usergrouppermisionset_allows" do
    it "should return true if there is at least one usergrouppermisionset that allows " do
      user = FactoryGirl.create :user
      usergroup = FactoryGirl.create :usergroup
      usergroup.users << user
      mediaresource = FactoryGirl.create :mediaresource
      usergrouppermisionset = FactoryGirl.create :usergrouppermisionset, :may_view => true, :usergroup => usergroup, :mediaresource => mediaresource
      (Permissions.usergrouppermisionset_allows :view, mediaresource, user).should == true
    end
    it "should return false if there is no usergrouppermisionset that allows " do
      user = FactoryGirl.create :user
      usergroup = FactoryGirl.create :usergroup
      usergroup.users << user
      mediaresource = FactoryGirl.create :mediaresource
      (Permissions.usergrouppermisionset_allows :view, mediaresource, user).should == false
    end
  end


end
