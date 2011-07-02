Feature: Manage deliveries
  In order to manage a CSA
  I want to create and manage deliveries

Background:
  Given there is a farm
  Given I am logged in as an admin
  When I follow "Soul Food Farm"

Scenario: Create A Delivery
  Given I am at Soul Food Farm
  Given the farm has a location "SF / Potrero" with host "Billy Baggins" and tag "SF-Potreo"
  Then I should see "Add New Delivery"
  When I follow "Add New Delivery"
  Then I should see "Minimum order total"
  And I should see "Select Locations:"
  And I should see "SF / Potrero"
  And I should not see "Someone's House"
  When I fill in the following:
    |delivery[date]|3/5/2010|
    |delivery_name|Hayes Valley|
  And I check "location_0"
  And I press "Create"
  Then I should see "Delivery was successfully created"
  And I should see "Hayes Valley"



Scenario: Entering Finalized Totals
  Given there is a "inprogress" delivery "SF - Hayes Valley"
  When I go to the delivery "SF - Hayes Valley"
  When I follow "Enter Finalized Totals"
  Then I should see "Finalized Total"
  And I should see "Anderson"
  When I fill in the following:
    |delivery_orders_attributes_0_finalized_total|11.11|
    |delivery_orders_attributes_1_finalized_total|22.22|
    |delivery_orders_attributes_2_finalized_total|33.33|
  And I press "Update"
  Then I should see "Delivery was successfully updated"
  And I should see "Enter Finalized Totals"

Scenario: Reducing quantity of a stock_item after orders are placed for it
  Given there is a "inprogress" delivery "SF - Hayes Valley"
  Given the delivery has a stock_item with negative availability
  When I go to the delivery "SF - Hayes Valley"
  Then I should see "Chicken, REGULAR - NEGATIVE"
  And I should see "-1"