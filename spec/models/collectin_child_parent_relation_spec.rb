require 'spec_helper'

describe "Collection-Child-Parent Relation" do

  it "should not be possible to make a colletion be a paraent of its own" do
    c = FactoryGirl.create :collection
    expect{ c.children << c }.to raise_error
  end


  it "should not be possible to insert a backwards edge" do
    c1 = FactoryGirl.create :collection
    c2 = FactoryGirl.create :collection
    c1.children << c2
    expect{ c2.children << c1 }.to raise_error
 end

  it "should not be possible to construct a cyclic trinagle" do
    a = FactoryGirl.create :collection
    b = FactoryGirl.create :collection
    c = FactoryGirl.create :collection
    a.children << b
    b.children << c
    expect{ c.children << a }.to raise_error
  end

end



