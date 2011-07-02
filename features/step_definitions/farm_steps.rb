def farm
  @farm ||= Factory :farm
end

Given /^there is a farm "([^\"]*)"$/ do |farm_name|
  @farm = Factory(:farm, :name => farm_name)
end

Given /^there is a farm$/ do
  farm
end

Given /^the farm has a location "([^\"]*)" with host "([^\"]*)" and tag "([^\"]*)"$/ do |location_name, host_name, tag|
  Given 'there is a farm'
  Factory.create(:location, :name => location_name, :host_name => host_name, :farm => @farm, :tag => tag)
end

Given /^the farm has the member "([^\"]*)"$/ do |member_name|
  Given 'there is a farm'
  name = member_name.split(' ')
  member = Factory.create(:member, :first_name => name[0], :last_name => name[1], :joined_on => Date.parse("Mon, 22 Mar 2010"))
  account = Factory.create(:account, :member => member, :farm => @farm)
  account.pending = false
  account.save!
  
  Factory.create(:user, :member => member, :email => member.email_address)
end

Given /^there is a snippet for "([^"]*)" with "([^"]*)"$/ do |identifier, body_text|
  Snippet.create!(:farm => @farm, :identifier => identifier, :body => body_text)
end
