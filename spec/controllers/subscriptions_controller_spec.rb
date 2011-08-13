require 'spec_helper'

describe SubscriptionsController do

  before(:each) do
    activate_authlogic
    UserSession.create Factory(:admin_user)
  end

  describe "GET 'index'" do
    it "should be successful" do
      get 'index', :product_id => Factory(:product)
      response.should be_success
    end
  end

  describe "GET 'show'" do
    it "should be successful" do
      get 'show'
      response.should be_success
    end
  end

end
