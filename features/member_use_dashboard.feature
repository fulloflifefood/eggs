Feature: Member Uses Dashboard
  As a Member
  In order to use the system
  I want to be able to view and use my dashboard

Background:
  Given there is a farm "Soul Food Farm"
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

Scenario: Don't see email reminders if disabled for farm
  Given I am on home
  Then I should not see "Manage email reminders"

Scenario: Don't see email reminders if no location_tags
  Given the farm has "reminders_enabled" as "false"    
  Given the farm has "0" location tags
  Given I am on home
  Then I should not see "Manage email reminders"


Scenario: Manage email reminders
  Given the farm has "reminders_enabled" as "true"
  Given the farm has "3" location tags
  Given I am on home
  Then I should see "Manage email reminders"