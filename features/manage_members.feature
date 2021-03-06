Feature: Manage Members
  In order to manage a CSA delivery
  I want to be able to view and manage members

Background:
  Given there is a farm "Soul Food Farm"
  Given I am the registered admin user jennyjones@kathrynaaker.com
  And I am on login
  When I login with valid credentials
  Then I should see "Soul Food Farm"
  Then I should see "Members" within "#manage_farm_links"

Scenario: View list of members
  Given the farm has the member "Billy Bobbins"
  Given the farm has the member "Suzy Smith"
  Given the member "Bobbins" is pending
  When I follow "Members" within "#manage_farm_links"
  Then I should see "Bobbins (pending)"
  And I should see "Soul Food Farm"
  And I should see "Smith"
  And I should not see "Smith (pending)"

Scenario: Add account_transaction for member through details page
  Given the farm has the member "Suzy Smith"
  When I follow "Members" within "#manage_farm_links"
  Then I should see "Smith"
  When I follow "Smith"
  Then I should see "Add AccountTransaction"
  When I follow "Add AccountTransaction"
  Then I should see "Current Balance: $0.00"
  Then "credit" should be selected for "account_transaction_debit"

Scenario: View and change a member's joined_on date
  Given the farm has the member "Suzy Smith"
  When I follow "Members" within "#manage_farm_links"
  Then I should see "Smith"
  When I follow "Smith"
  Then I should see "March 22, 2010"
  When I follow "Edit Member Information"
  Then I should see "Admin use"
  And I should see "Joined on:"
  Then "2010" should be selected for "member_joined_on_1i"
  Then "March" should be selected for "member_joined_on_2i"
  Then "22" should be selected for "member_joined_on_3i"
  When I select "10" from "member_joined_on_3i"
  And I press "Submit"
  Then I should see "March 10, 2010"

Scenario: Add a manager-only note for a member
  Given the farm has the member "Suzy Smith"
  When I follow "Members" within "#manage_farm_links"
  When I follow "Smith"
  Then I should see "Member Details:"
  And I should see "Private Member notes:"
  When I follow "Edit Member Information"
  Then I should see "Private notes (only admins see):"
  Then I should see "" within "#private_notes"
  When I fill in "private_notes" with "Always late!"
  And I press "Submit"
  Then I should see "updated"
  And I should see "Always late!"


