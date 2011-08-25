Feature: Manage Members
  In order to manage multiple farms
  I want to be able to view and manage members separately for each farm

Background:
  Given there is a farm "Clark Summit Farm"
  Given there is a "open" delivery "Emeryville - Clark"
  Given there is a farm "Soul Food Farm"
  Given there is a "open" delivery "Hayes Valley - Soul Food"
  Given I am the registered admin user jennyjones@kathrynaaker.com
  And I am on login
  When I login with valid credentials
  Then I should see "Soul Food Farm"
  When I follow "Soul Food Farm"
  Then I should see "Members" within "#manage_farm_links"


Scenario: View member details
  Given the farm has the member "Billy Bobbins"
  Given the member "Bobbins" has orders for all farms
  When I follow "Members" within "#manage_farm_links"
  Then I should see "Bobbins"
  When I follow "Bobbins"
  Then I should see "Bobbins, Billy"
  And I should see "Hayes Valley - Soul Food"
  And I should not see "Emeryville - Clark"