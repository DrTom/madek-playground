require 'spec_helper'

describe Usergroup do

  it "should be valid when created by default factory" do 
    (FactoryGirl.create :usergroup).should be_valid 
  end

end
