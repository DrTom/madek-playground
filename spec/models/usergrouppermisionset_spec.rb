require 'spec_helper'

describe Mediaresourcegrouppermission do
  it "should be producible by a factory" do
    FactoryGirl.create :usergroup
    FactoryGirl.create :mediaresource
    (FactoryGirl.create :mediaresourcegrouppermission).should_not == nil
  end
end
