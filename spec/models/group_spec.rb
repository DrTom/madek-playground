require 'spec_helper'

describe Group do

  it "should be valid when created by default factory" do 
    (FactoryGirl.create :group).should be_valid 
  end

end
