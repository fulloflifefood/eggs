Feature: Login and Logout
  In order to secure private information
  I need to be able to only view data when logged in

Scenario: Logging in and out
  Given there is a farm
  Given I am the registered admin user jennyjones@kathrynaaker.com
  And I am on login
  When I login with valid credentials
  Then I should not see "You are being redirected"
  Then I should see "Soul Food Farm"
  And I follow "Log out"
  And I go to farms
  Then I should see "You must log in to access this page"

Scenario: Failed login with invalid email
  Given there is a farm
  Given I am the registered admin user jennyjones@kathrynaaker.com
  And I am on login
  When I fill in "user_session_email" with "foo@kathrynaaker.com"
  And I fill in "user_session_password" with "eggsrock"
  And I press "Login"
  Then I should see "Email"  
  Then the "Email" field should contain "foo@kathrynaaker.com"
