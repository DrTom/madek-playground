require 'spec_helper'

describe "A public viewable Mediaresource" do
  mediaresource = FactoryGirl.create :mediaresource, :perm_public_view => true

  it "should be viewalbe by an unrelated user" do
    user = FactoryGirl.create :user
    mediaresource.can_view?(user).should equal true
  end

  it "should be viewable by an user, even when the user is not allowed by user permissions" do
    user = FactoryGirl.create :user
    userpermissionset = FactoryGirl.create :userpermissionset, :user => user, :mediaresource => mediaresource, :not_view => true
    mediaresource.can_view?(user).should equal true
  end

end


describe "A non public viewable, non public downloadable Mediaresource" do
  mediaresource = FactoryGirl.create :mediaresource, :perm_public_view => false, :perm_public_download => false

  it "should not be viewable by an user without any permissions" do
    user = FactoryGirl.create :user
    mediaresource.can_view?(user).should equal false
  end

  it "should be be viewable for an user when specified by a userpermissionset" do
    user = FactoryGirl.create :user
    userpermissionset = FactoryGirl.create :userpermissionset, :view => true, :user => user, :mediaresource => mediaresource
    mediaresource.can_view?(user).should equal false
  end

  it "should be be viewable for an user when the user belongs to a usergrouppermisionset with given view rights" do
    user = FactoryGirl.create :user
    group = FactoryGirl.create :usergroup
    group.users << user
    usergrouppermisionset = FactoryGirl.create :usergrouppermisionset, :view => true, :usergroup => group, :mediaresource => mediaresource
    mediaresource.can_view?(user).should equal false
  end


end
