require 'spec_helper'

describe Mediaresource do

  it "should be creatable by a factory" do
    (FactoryGirl.create :mediaresource).should_not == nil
  end

  it "should have an owner" do
    (FactoryGirl.create :mediaresource).owner.should_not == nil
  end

  context "data consistency" do
    it "should raise an error if the owner of an mediaresource is destroyed" do
      expect { (FactoryGirl.create :mediaresource).owner.destroy }.to raise_error
    end
  end

end


