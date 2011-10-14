require 'spec_helper'

describe Mediaresource do
  it "should be creatable by a factory" do
    (FactoryGirl.create :mediaresource).should_not == nil
  end
end


