Feature: Member Manages an Account
  As a Member
  In order to use the system
  I want to be able to view and use my dashboard

Background:
  Given there is a farm
  Given I am the registered member user benbrown@kathrynaaker.com
  Given there is a "open" delivery "Mission / Potrero"

  And I am on login
  When I login with valid credentials
  Then I should see "Welcome"

Scenario: View template text with rendered HTML
  Given there is a snippet for "welcome_home" with "<h5>Welcome to Soul Food Farm</h5>"  
  Given I am on home
  Then I should see "Welcome to Soul Food Farm"
  Then I should not see "<h5>"
