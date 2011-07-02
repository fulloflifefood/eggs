require 'spec_helper'

describe DeliveriesController do
  before(:each) do
    activate_authlogic
    UserSession.create Factory(:admin_user)
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

    location1 = Factory(:location, :farm => farm, :name => "Potrero", :tag => "SF-Potrero")
    location2 = Factory(:location, :farm => farm, :name => "Elsewhere", :tag => "Elsewhere")

    get :create, :location_ids => [location1.id,location2.id],
          :farm_id => farm.id,
          :delivery => {:farm_id => farm.id, :date => '2010-03-01'}

    assigns[:delivery].locations.first.should_not be_nil
    assigns[:delivery].locations.size.should == 2
  end

  it "should update delivery statuses on show" do
    farm = Factory(:farm)
    delivery = Factory(:delivery, :status => 'notyetopen',
                       :opening_at => Time.current - 10.minutes, :farm => farm,
                       :status_override => false)

    get :show, :id => delivery.id

    response.should be_success
    delivery.reload
    delivery.status.should == 'open'
  end

  it "should set status_override if status is manually changed" do
    farm = Factory(:farm)
    delivery = Factory(:delivery, :status => 'inprogress', :farm => farm, :status_override => false)

    get :update,  :id => delivery.id,
                  :farm_id => farm.id,
                  :delivery => {}

    response.should be_redirect
    delivery.reload
    delivery.status_override.should == false

    get :update,  :id => delivery.id,
                  :farm_id => farm.id,
                  :delivery => {:status => 'open'}


    delivery.reload
    delivery.status_override.should == true
  end

  it "should update finalized totals and set a flag on the delivery" do
    farm = Factory(:farm)
    delivery = Factory(:delivery, :status => 'inprogress', :farm => farm)
    delivery.orders << Factory.create(:order, :delivery => delivery)

    get :update_finalized_totals, :id => delivery.id,
                                  :farm_id => farm.id,
                                  :totals => "true",
                                  :delivery => {"orders_attributes"=>{"0"=>{"finalized_total"=>"86", "id"=>delivery.orders.first.id}}}


    delivery.reload
    delivery.finalized_totals.should == true
    delivery.orders.first.finalized_total.should == 86

  end

  it "should delete reminders when deleting a delivery" do


    farm = Factory(:farm, :reminders_enabled => true)
    delivery = Factory(:delivery, :status => 'open', :farm => farm)

    Factory.create(:email_template, :identifier => "order_reminder", :farm => farm)
    Factory.create(:email_template, :identifier => "order_reminder_last_call", :farm => farm)

    reminder_manager = ReminderManager.new
    reminder_manager.schedule_reminders_for_delivery(delivery)

    reminders = DeliveryOrderReminder.find_all_by_delivery_id(delivery.id)
    reminders.size.should == 2

    get :destroy, :id => delivery.id, :farm_id => farm.id

    reminders = DeliveryOrderReminder.find_all_by_delivery_id(delivery.id)
    reminders.size.should == 0

  end

end
