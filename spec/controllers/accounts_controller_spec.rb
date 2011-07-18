require 'spec_helper'

describe AccountsController do
  before(:each) do
    activate_authlogic
  end

  describe "#edit_reminder_locations" do
    before(:each) do
      @farm = Factory(:farm_with_locations)
      @member = Factory(:member)
      @user = Factory(:member_user, :member => @member)
      @account = Factory(:account, :member => @member, :farm => @farm)
      UserSession.create @user
    end

    it "should accept a list of location_tag ids and save the location tags to the account" do
      get :edit_reminder_locations, :id => @farm.locations.first.id, :farm_id => @farm.id,
                    "location_tags"=>["#{@farm.location_tags.first.id}", "#{@farm.location_tags.all[1].id}"]

      response.body.should == "success"
      @account.location_tags.size.should == 2
    end
    
  end

end
