require 'spec_helper'

describe Usergroup do

  it "should be creatable by a factory" do
    (FactoryGirl.create :usergroup).should_not == nil
  end

end
