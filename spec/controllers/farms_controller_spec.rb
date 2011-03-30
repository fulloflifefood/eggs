require 'spec_helper'

describe FarmsController do
  before(:each) do
    activate_authlogic
    UserSession.create Factory(:admin_user)
  end


  it "should succeed if we are authenticated" do
    get :index
    response.should be_success
  end

  it "should only index farms for which the admin belongs" do
    Factory(:farm, :name => "Soul Food Farm")
    farm1 = Factory(:farm, :name => "Clark Summit Farm")
    farm2 = Factory(:farm, :name => "Another Farm")


    UserSession.find.user.has_role!(:admin, farm1)
    UserSession.find.user.has_role!(:admin, farm2)
    get :index

    assigns(:farms).size.should == 2

  end

  it "should redirect to the farm if only one" do
    farm = Factory(:farm, :name => "Soul Food Farm")
    Factory(:farm, :name => "Another Farm")

    UserSession.find.user.has_role!(:admin, farm)
    get :index

    response.should redirect_to(farm)
  end

  it "should create sets of deliveries when showing a single farm" do
    farm = Factory(:farm_with_deliveries)

    get :show, :id => farm.id
    response.should be_success

    assigns(:deliveries_inprogress).size.should == 2
    assigns(:deliveries_open).size.should == 1
    assigns(:deliveries_notyetopen).size.should == 1
    assigns(:deliveries_archived).size.should == 1
    assigns(:deliveries_finalized).size.should == 1
    
  end

  it "should update deliveries on show" do
    farm = Factory(:farm_with_deliveries)
    delivery = Factory(:delivery, :status => 'notyetopen',
                       :opening_at => Time.current - 10.minutes, :farm => farm,
                       :status_override => false)

    get :show, :id => farm.id

    delivery.reload
    delivery.status.should == 'open'

  end

  it "should set an array of subscribable products" do
    farm = Factory(:farm)
    farm.products << Factory(:product, :name => "Eggs", :subscribable => true, :farm => farm)
    farm.products << Factory(:product, :name => "Veggie Box", :subscribable => true, :farm => farm)
    farm.products << Factory(:product, :name => "Chickens", :subscribable => false, :farm => farm)
    product_to_exclude = Factory(:product, :name => "Beef", :subscribable => true)

    get :show, :id => farm.id
    assigns(:subscribable_products).size.should == 2

    assigns(:subscribable_products).include?(product_to_exclude).should == false

  end

end