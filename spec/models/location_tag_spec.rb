require 'spec_helper'

describe LocationTag do
  it "must belong to a farm and have a name" do
    LocationTag.new.valid?.should == false
    LocationTag.new(:farm => Factory(:farm)).valid?.should == false
    LocationTag.new(:name => "Potrero").valid?.should == false
    LocationTag.new(:name => "Potrero", :farm => Factory(:farm)).valid?.should == true
  end
end
