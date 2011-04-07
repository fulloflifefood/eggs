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

  Given the member "Bobbins" has a "Eggs" transaction "credit" for "100"
  Given the member "Bobbins" has a "Eggs" transaction "debit" for "3"
  Given the member "Smith" has a "Eggs" transaction "debit" for "17"


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

Scenario: Viewing list of transactions for a Subscription
  Given I am on the farm "Soul Food Farm"
  When I follow "Eggs"
  Then I should see "Bobbins"
  When I follow "Bobbins"
  Then I should see "Transaction History for: Bobbins"
  And I should see "Current Eggs Balance: 97"
  And I should see "+100"
  And I should not see "+100.0"
  And I should see "-3"
  And I should not see "17"

Scenario: Adding transaction for a Subscription
  Given I am on the farm "Soul Food Farm"
  When I follow "Eggs"
  And I follow "Bobbins"
