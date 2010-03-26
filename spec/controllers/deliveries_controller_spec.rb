require 'spec_helper'

describe DeliveriesController do
  before(:each) do
    activate_authlogic
    UserSession.create Factory(:user)
  end  

  it "should list deliveries only for soul food farm" do
    get :index, :farm_id => Factory(:farm)

    response.should be_success

    assigns(:deliveries).each do |p|
      p.farm.should == Factory(:farm)
    end

  end

  it "should redirect index if no farm id is given" do
    get :index

    response.should be_redirect
    
  end

  it "should create a delivery and pickups" do
    farm = Factory(:farm)

    location1 = Factory(:location, :farm => farm, :name => "Potrero")
    location2 = Factory(:location, :farm => farm, :name => "Elsewhere")

    get :create, :location_ids => [location1.id,location2.id],
          :farm_id => farm.id,
          :delivery => {:farm_id => farm.id, :date => '2010-03-01'}

    assigns[:delivery].locations.first.should_not be_nil
    assigns[:delivery].locations.size.should == 2
  end

end