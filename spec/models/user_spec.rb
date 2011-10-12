require 'spec_helper'

describe User do

  it "should be valid when created by default factory" do 
    (FactoryGirl.create :user).should be_valid 
  end


end
