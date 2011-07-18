require 'spec_helper'

describe LocationTag do
  it "must belong to a farm and have a name" do
    LocationTag.new.valid?.should == false
    LocationTag.new(:farm => Factory(:farm)).valid?.should == false
    LocationTag.new(:name => "Potrero").valid?.should == false
    LocationTag.new(:name => "Potrero", :farm => Factory(:farm)).valid?.should == true
  end

  it "should update member reminder location tags with observer after create" do
    farm = Factory(:farm_with_members)
    potrero_tag = Factory(:location_tag, :name => "SF-Potrero", :farm => farm)

    farm.accounts.each do |account|
      account.location_tags.include?(potrero_tag).should == true
    end
  end
end
