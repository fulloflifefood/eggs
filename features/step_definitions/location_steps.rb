And /^I fill in the form with a location$/ do
  fill_in('location_name', :with => "SF / Potrero")
  fill_in('location_host_name', :with => "Billy Bobbins")
  fill_in('Host phone', :with => "1234567890")
  fill_in('Host email', :with => "billy@example.com")
  fill_in('Address', :with => "123 1st Street, SF, CA 94110")
  fill_in('location_time_window', :with => '5-7pm')
  fill_in('location_tag', :with => "SF-Potrero")
end
