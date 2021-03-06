require 'spec_helper'

describe UserSessionsController do
  before(:each) do
    activate_authlogic
  end

  it "should send an admin to the farms list after login" do
    u = Factory(:admin_user)

    post :create, :user_session => {:email => u.email, :password => u.password}
    response.should redirect_to(farms_path)
  end

  it "should send a member to their user page after login" do
    u = Factory(:member_user)

    post :create, :user_session => {:email => u.email, :password => u.password}
    response.should redirect_to(user_path(u))
  end

end
