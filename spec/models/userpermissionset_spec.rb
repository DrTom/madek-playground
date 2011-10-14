require 'spec_helper'

describe Userpermissionset do
  it "should be producible by a factory" do
    FactoryGirl.create :user
    FactoryGirl.create :mediaresource
    (FactoryGirl.create :userpermissionset).should_not == nil
  end

end
