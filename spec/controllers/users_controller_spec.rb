require 'spec_helper'

describe UsersController do
  before(:each) do
    activate_authlogic
  end

  describe "show" do
    before(:each) do
      @farm = Factory(:farm_with_locations)
      @member = Factory(:member)
      @user = Factory(:member_user, :member => @member)
      @account = Factory(:account, :member => @member, :farm => @farm)
      UserSession.create @user
    end

    it "should let a member view their own page" do
      get :show, :id => @member.id, :farm_id => @farm.id

      response.should be_success
      response.should render_template('home')
    end

    it "should assign a account when rendering home" do

      get :show, :farm_id => @farm.id, :id => @user.id

      response.should  render_template('users/home')
      assigns(:account).should == @account

    end


    it "should assign location_tags" do
      @account.location_tags.clear
      @account.location_tags << [@farm.location_tags.all[0], @farm.location_tags.all[1]]

      get :show, :farm_id => @farm.id, :id => @user.id
      assigns(:location_tags).size.should == 5
      assigns(:account_location_tags).size.should == 2

    end


    it "should trigger a delivery status update" do

      delivery = Factory(:delivery, :status => 'notyetopen',
                         :opening_at => Time.current - 10.minutes, :farm => @farm,
                         :status_override => false)

      get :show, :id => @member.id, :farm_id => @farm.id

      delivery.reload
      delivery.status.should == 'open'

    end
  end

  it "should deny a non-admin member from seeing the index of users" do
    user = Factory(:member_user)
    UserSession.create user
    get :index
    response.should render_template('home/access_denied')
  end


  it "should allow an admin to see the index" do
    admin = Factory(:admin_user)
    UserSession.create admin
    get :index, :farm_id => Factory(:farm).id
    response.should render_template('index')
  end

  it "should only have users from the specified farm in index" do
    admin = Factory(:admin_user)
    UserSession.create admin

    farm1 = Factory(:farm_with_members)
    farm2 = Factory(:farm_with_members)

    get :index, :farm_id => farm1.id

    assigns(:users).each do |user|
      user.member.farms.include?(farm1).should == true
    end
  end

  it "should assign an account when rendering home" do
    farm = Factory(:farm)
    member = Factory(:member)
    user = Factory(:member_user, :member => member)
    account = Factory(:account, :member => member, :farm => farm)

    UserSession.create user
    get :show, :farm_id => farm.id, :id => user.id

    response.should  render_template('users/home')
    assigns(:account).should == account
    
  end

  it "should let members only edit their own user profile" do
    member = Factory(:member_user)
    farm = Factory(:farm)
    UserSession.create member
    get :edit, :id => member.id, :farm_id => farm.id
    assigns(:user).should == member

    get :edit, :id => 34
    assigns(:user).should == member

  end

  it "should allow admins to edit any user profile" do
    admin = Factory(:admin_user)
    UserSession.create admin
    member = Factory(:member_user)

    get :edit, :id => member.id
    assigns(:user).should == member

  end

  it "should update member attributes" do
    member_user = Factory(:member_user)
    UserSession.create member_user

    get :update, "id" => member_user.id,
                 "user"=>{"password_confirmation"=>"[FILTERED]",
                          "member_attributes"=>{"address"=>"Somewhere over the rainbow...",
                                                "alternate_email"=>"",
                                                "id"=>member_user.member.id,
                                                "phone_number"=>"333-444-5555",
                                                "last_name"=>"Brown",
                                                "first_name"=>"Ben"},
                          "password"=>"[FILTERED]",
                          "email"=>"ben@kathrynaaker.com"}

    response.should be_redirect
    assigns(:user).should == member_user
    assigns(:user).member.first_name.should == "Ben"
    assigns(:user).email.should == "ben@kathrynaaker.com"
    assigns(:user).member.email_address.should == "ben@kathrynaaker.com"
    
  end



end