Feature: Member Uses Subscriptions
  As a Member with a subscription to a product
  I want to be able to order the products and view history

Background:
  Given there is a farm "Soul Food Farm"
  Given there is a member user with the following attributes:
    | first_name  | last_name | email_address         |
    | Bill        | Brick     | benbrown@example.com  |
    | Kathryn     | Aaker     | kathryn@example.com   |
  Given I am the registered member user benbrown@example.com
  Given there is a "open" delivery "Mission / Potrero"
  Given the delivery "Mission / Potrero" has the stock_item "EggShare Eggs" with a price of 0
  Given the delivery "Mission / Potrero" has the stock_item "Veggie Box" with a price of 0

  Given the product "EggShare Eggs" is subscribable
  Given the product "Veggie Box" is subscribable
  Given the member "Brick" has a subscription for "EggShare Eggs"

  Given the member "Brick" has a "EggShare Eggs" transaction "credit" for "100"
  Given the member "Brick" has a "EggShare Eggs" transaction "debit" for "3"
  Given the member "Brick" has a "EggShare Eggs" transaction "debit" for "17"

  And I am on login
  When I login with valid credentials
  Then I should see "Welcome"
  And I should see "Bill Brick"

Scenario: See subscription with current balance
  Given I am on home
  Then I should see "EggShare Eggs"
  And I should see "Current Balance: 80"

Scenario: View history
  Given I am on home
  Then I should see "EggShare Eggs"
  And I should see "History"
  When I follow "History"
  Then I should see "100"
  And I should see "-3"
  And I should see "-17"
  And I should see "Back to Dashboard"
  And I should not see "Back to subscriptions"

Scenario: I should only see subscribable products if I have a subscription
  Given I am on home
  Then I should see "EggShare Eggs"
  And I should not see "Veggie Box"
  And I should see "Mission / Potrero"
  When I follow "Mission / Potrero"
  Then I should see "EggShare Eggs"
  And I should not see "Veggie Box"