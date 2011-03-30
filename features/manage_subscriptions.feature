Feature: Manage Subscriptions
  As a manager
  In order to allow users to order subscribable products
  I must be able to view and manage subscriptions for products

Background:
  Given there is a farm
  Given the product "Eggs" is subscribable
  Given the product "Veggie Box" is subscribable
  Given the farm has the member "Billy Bobbins"
  Given the farm has the member "Suzy Smith"
  Given the farm has the member "Charlie Chase"

  Given the member "Bobbins" has a subscription for "Eggs"
  Given the member "Smith" has a subscription for "Eggs"
  Given I am logged in as an admin
  Given I am on farms
  When I follow "Soul Food Farm"
  Then I should see "Subscriptions / Shares:"

Scenario: Viewing list of Subscriptions
  Given I am on the farm "Soul Food Farm"
  Then I should see "Soul Food Farm - Home"
  And I should see "Eggs"
  When I follow "Eggs"
  Then I should see "Eggs Subscribers:"
  And I should see "Bobbins"
  And I should see "Smith"
  And I should not see "Chase"