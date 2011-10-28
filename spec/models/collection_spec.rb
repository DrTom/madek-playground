require 'spec_helper'

describe Collection do

  it "should be creatable by a factory" do
    (FactoryGirl.create :collection).should_not == nil
  end

  it "should have an owner" do
    (FactoryGirl.create :collection).owner.should_not == nil
  end


  context "due to data consistency" do

    it "should raise an error if the owner is set to null on save!" do
      expect { FactoryGirl.create :collection, :owner_id => nil 
        }.to raise_error(ActiveRecord::StatementInvalid, /violates not-null constraint/)
    end

    it "should raise an error if the owner_id set an not existing user" do
      expect { FactoryGirl.create :collection, :owner_id => -1
        }.to raise_error(ActiveRecord::InvalidForeignKey)
    end

    it "should raise an error if the owner of an mediaresource is destroyed" do
      expect { (FactoryGirl.create :collection).owner.destroy 
        }.to raise_error(ActiveRecord::InvalidForeignKey)
    end

  end



end
