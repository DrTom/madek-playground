require 'spec_helper'

describe "Permissions" do

  describe "A public viewable Mediaresource" do

    before(:each) do
      DatasetFactory.clear
      @mediaresource = FactoryGirl.create :mediaresource, :perm_public_may_view => true, :owner => (FactoryGirl.create :user)
      @user = FactoryGirl.create :user
    end

    it "should be viewalbe by an unrelated user" do
      (Permissions.can_view? @mediaresource, @user).should == true
    end

    it "should be included in the users viewable mediaresources" do
      @user.viewable_mediaresources.should include @mediaresource
    end

    context "the user is not allowed by user permissions" do

      before(:each) do
        FactoryGirl.create :mediaresourceuserpermission, :user => @user, :mediaresource => @mediaresource, :maynot_view => true
      end

      it "should be viewable by the user" do
        (Permissions.can_view? @mediaresource, @user).should == true
      end

      it "should be included in the users viewable mediaresources" do
        @user.viewable_mediaresources.should include @mediaresource
      end

    end
  end


  describe "A non public viewable Mediaresource" do 

    before(:each) do
      DatasetFactory.clear
      @owner = (FactoryGirl.create :user)
      @mediaresource = FactoryGirl.create :mediaresource, :perm_public_may_view => false, :owner => @owner 
    end

    it "can be viewed by its owner"  do
      (Permissions.can_view? @mediaresource, @owner).should == true
    end

    it "should be included in the owners viewable mediaresources" do
      @owner.viewable_mediaresources.should include @mediaresource
    end


    it "can be viewed by its owner even if the owner is disallowed by mediaresourceuserpermissions"  do
      FactoryGirl.create :mediaresourceuserpermission, :may_view =>false, :maynot_view => true, :mediaresource => @mediaresource, :user => @owner
      (Permissions.can_view? @mediaresource, @owner).should == true
    end

    it "should be included in the viewable_mediaresources even if the owner is disallowed by mediaresourceuserpermissions"  do
      FactoryGirl.create :mediaresourceuserpermission, :may_view =>false, :maynot_view => true, :mediaresource => @mediaresource, :user => @owner
      @owner.viewable_mediaresources.should include @mediaresource
    end

  end


  describe "A non public viewable Mediaresource" do

    before(:each) do
      DatasetFactory.clear
      @mediaresource = FactoryGirl.create :mediaresource, :perm_public_may_view => false, :owner => (FactoryGirl.create :user)
      @user = FactoryGirl.create :user
    end


    it "should not be viewable by an user without any permissions" do
      (Permissions.can_view? @mediaresource, @user).should == false
    end

    it "should not be included in the users viewable mediaresources" do
      @user.viewable_mediaresources.should_not include @mediaresource
    end

    context "a mediaresourceuserpermission allows the user" do
      before(:each) do
        FactoryGirl.create :mediaresourceuserpermission, :may_view => true, :user => @user, :mediaresource => @mediaresource
      end


      it "should be be viewable for the user" do
        (Permissions.can_view? @mediaresource,@user).should == true
      end

      it "should be included in the users viewable mediaresources" do
        @user.viewable_mediaresources.should include @mediaresource
      end

    end

    context "a mediaresourcegrouppermission allows the user to view" do

      before(:each) do
        @group = FactoryGirl.create :usergroup
        @group.users << @user
        FactoryGirl.create :mediaresourcegrouppermission, :may_view => true, :usergroup => @group, :mediaresource => @mediaresource
      end

      it "should be be viewable for the user" do
        (Permissions.can_view? @mediaresource, @user).should == true
      end

      it "should be included in the users viewable mediaresources" do
        @user.viewable_mediaresources.should include @mediaresource
      end

      context "a mediaresourceuserpermission denies the user to view" do

        before(:each) do
          FactoryGirl.create :mediaresourceuserpermission, :may_view =>false, :maynot_view => true, :mediaresource => @mediaresource, :user => @user
        end

        it "should not be viewable for the user" do
          (Permissions.can_view? @mediaresource,@user).should == false
        end

        it "should be included in the users viewable mediaresources" do
          @user.viewable_mediaresources.should_not include @mediaresource
        end

      end
    end
  end
end

