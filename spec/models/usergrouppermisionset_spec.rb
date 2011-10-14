require 'spec_helper'

describe Usergrouppermisionset do
  it "should be producible by a factory" do
    FactoryGirl.create :usergroup
    FactoryGirl.create :mediaresource
    (FactoryGirl.create :usergrouppermisionset).should_not == nil
  end
end
