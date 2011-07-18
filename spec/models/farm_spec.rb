# == Schema Information
#
# Table name: farms
#
#  id            :integer(4)      not null, primary key
#  name          :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  key           :string(255)
#  paypal_link   :string(255)
#  contact_email :string(255)
#  contact_name  :string(255)
#

require 'spec_helper'

describe Farm do
  before(:each) do
    @valid_attributes = {
      :name => "Soul Food Farm"
    }
  end

  it "should create a new instance given valid attributes" do
    Farm.create!(@valid_attributes)
  end

  it "should not allow saving of a new instance without name" do
    f = Farm.new
    f.valid?.should == false
  end

  it "should have a list of users for that farm" do
    f = Factory(:farm_with_members)
    f.members.length.should >= 1
  end

  it "should be able to store contact info and payment URL" do
    f = Factory(:farm_with_details)
    f.paypal_link.should == "http://paypal.pay.me/please"
    f.contact_email.should == "csa@example.com"
    f.contact_name.should == "Kathryn Aaker"
    f.paypal_account.should == "csa@example.com"
  end

  it "should be able to have mailinglist, deposit and referral be optional" do
    f = Factory(:farm_with_details)
    f.require_deposit.should == true
    f.require_mailinglist.should == true
    f.request_referral.should == true
  end

  it "can have a list of addresses to use for paypal" do
    farm_sff = Factory(:farm_with_details)
    farm_cs = Factory(:farm_with_details)


    farm_sff.has_paypal_address?(farm_sff.paypal_account).should == true

    farm_sff.update_attribute("paypal_account", "farm_sff@example.com,othersffemail@aol.com")
    farm_sff.has_paypal_address?("farm_sff@example.com").should == true
    farm_sff.has_paypal_address?("nunuh@example..com").should == false

    farm_cs.update_attribute("paypal_account", "farm_cs@example.com,new@example.com")

    Farm.find_by_paypal_address("farm_cs@example.com").should == farm_cs
    Farm.find_by_paypal_address("farm_sff@example.com").should == farm_sff
    Farm.find_by_paypal_address("othersffemail@aol.com").should == farm_sff
    Farm.find_by_paypal_address("foo@example.com").should == nil

    
  end

  it "can return a list of unique location tags" do
    farm = Factory(:farm_with_locations)

    farm.location_tags.size.should == 5
    farm.location_tags.first.name.should == "SF-Potrero" 
  end

end
