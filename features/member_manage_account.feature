Feature: Member Manages an Account
  As a Member
  In order to pay for orders
  I want to manage my account

Background:
  Given there is a farm
  Given I am the registered member user benbrown@kathrynaaker.com
  Given there is a "open" delivery "Mission / Potrero"
  And I am on login
  When I login with valid credentials
  Then I should see "Welcome"


Scenario: See a positive account balance
  Given I have a balance of "12"
  When I go to home
  Then I should see "Mission / Potrero"
  Then I should see "Credit: $12.00"

Scenario: See a negative account balance
  Given I have a balance of "-12"
  When I go to home
  Then I should see "Mission / Potrero"
  Then I should see "-$12.00"
  And I should not see "Credit:"

Scenario: Update member name with password change
  When I follow "user_settings"
  Then I should see "Member Info"
  When I fill in the following:
    | user_member_attributes_first_name       | Susan       |
    | user_member_attributes_last_name        | Smith       |
    | user_password                           | eggbasket!  |
    | user_password_confirmation              | eggbasket!  |
  And I press "Update"
  Then I should see "Thanks for updating your information!"

Scenario: Update member name without password change
  When I follow "user_settings"
  Then I should see "Member Info"
  When I fill in the following:
    | user_member_attributes_first_name       | Susan       |
    | user_member_attributes_last_name        | Smith       |
  And I press "Update"
  Then I should see "Thanks for updating your information!"
