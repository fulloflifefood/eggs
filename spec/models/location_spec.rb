# == Schema Information
#
# Table name: locations
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  host_name   :string(255)
#  host_phone  :string(255)
#  host_email  :string(255)
#  address     :string(255)
#  notes       :text
#  time_window :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  farm_id     :integer(4)
#

require 'spec_helper'

describe Location do

  it "should update member reminder location tags with observer after create" do
    farm = Factory(:farm_with_members)
    potrero_tag = Factory(:location_tag, :name => "SF-Potrero")
    farm_tag = Factory(:location_tag, :name => "Farm")
    Factory(:location, :farm => farm, :location_tag => potrero_tag)

    farm.members.each do |member|
      member.account_for_farm(farm).location_tags.include?(potrero_tag).should == true
      member.account_for_farm(farm).location_tags.include?(farm_tag).should == false
    end

    Factory(:location, :farm => farm, :location_tag => potrero_tag)
    farm.members.first.account_for_farm(farm).location_tags.size.should == 1
    
  end

end