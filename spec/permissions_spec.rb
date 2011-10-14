require 'spec_helper'


describe "A public viewable Mediaresource" do
  mediaresource = FactoryGirl.create :mediaresource, :perm_public_may_view => true

  it "should be viewalbe by an unrelated user" do
    user = FactoryGirl.create :user
    (Permissions.can_view? mediaresource, user).should equal true
  end

  it "should be viewable by an user, even when the user is not allowed by user permissions" do
    user = FactoryGirl.create :user
    userpermissionset = FactoryGirl.create :userpermissionset, :user => user, :mediaresource => mediaresource, :maynot_view => true
    (Permissions.can_view? mediaresource, user).should equal true
  end

end


describe "A non public viewable Mediaresource" do
  mediaresource = FactoryGirl.create :mediaresource, :perm_public_may_view => false

  it "should not be viewable by an user without any permissions" do
    user = FactoryGirl.create :user
    (Permissions.can_view? mediaresource,user).should equal false
  end

  it "should be be viewable for an user when specified by a userpermissionset" do
    user = FactoryGirl.create :user
    userpermissionset = FactoryGirl.create :userpermissionset, :may_view => true, :user => user, :mediaresource => mediaresource
    (Permissions.can_view? mediaresource,user).should equal true
  end

  it "should be be viewable for an user when the user belongs to a usergrouppermisionset with given view rights" do
    user = FactoryGirl.create :user
    group = FactoryGirl.create :usergroup
    group.users << user
    usergrouppermisionset = FactoryGirl.create :usergrouppermisionset, :may_view => true, :usergroup => group, :mediaresource => mediaresource
    (Permissions.can_view? mediaresource, user).should equal true
  end

  it "should not be viewable for an user when the user belongs to a usergrouppermisionset with given view permission but is denied to view through a userpermissionset" do
    user = FactoryGirl.create :user
    group = FactoryGirl.create :usergroup
    group.users << user
    usergrouppermisionset = FactoryGirl.create :usergrouppermisionset, :may_view => true, :usergroup => group, :mediaresource => mediaresource
    userpermissionset = FactoryGirl.create :userpermissionset, :may_view =>false, :maynot_view => true, :mediaresource => mediaresource
    (Permissions.can_view? mediaresource,user).should equal false
  end

end
