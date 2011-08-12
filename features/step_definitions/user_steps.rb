Given /^I am the registered admin user (.+)$/ do |login|
  params = {
    "email"=> login,
    "password"=>"eggsrock",
    "password_confirmation"=>"eggsrock"
  }
  @user = User.create!(params)
  @user.active = true


  @user.member = Member.create!(:email_address => @user.email,
                                 :first_name => "Soul Food",
                                 :last_name => "Farm",
                                 :phone_number => '1234556323')

  @user.save!
  
  Farm.all.each{|farm| @user.has_role!(:admin, farm)}
end


Given /^I am the registered member user (.+)$/ do |login|
  params = {
    "email"=> login,
    "password"=>"eggsrock",
    "password_confirmation"=>"eggsrock"
  }
  @user = User.find_by_email(login) || User.create!(params)
  @user.has_role!(:member)
  @user.active = true
  @user.member = @user.member || Factory(:member, :email_address => login)
  @user.member.farms << @farm
  @user.save!
end

Given /^there is a member user with the following attributes:$/ do |table|
  table.hashes.each do |attributes|
    member = Factory(:member)
    member.email_address = attributes['email_address']
    member.first_name = attributes['first_name']
    member.last_name = attributes['last_name']
    member.farms << @farm
    member.save!
    user = User.create!(:email => member.email_address, :password => 'eggsrock', :password_confirmation => 'eggsrock')
    user.has_role!(:member, @farm)
    user.active = true
    user.member = member
    user.save!
  end
end



When /^I login with valid credentials$/ do
  fill_in('user_session_email', :with => @user.email)
  fill_in('user_session_password', :with => "eggsrock")
  click_button("Login")
end

Given /^I am logged in as an admin$/ do
  Given "I am the registered admin user jennyjones@kathrynaaker.com"
  And "I am on login"
  Given "I login with valid credentials"
end
