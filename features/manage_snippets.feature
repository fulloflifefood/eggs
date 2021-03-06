Feature: Manage Snippet
  In order for managers to show semi-static content
  They must be able to add/edit snippets of text

Background:
  Given there is a farm "Soul Food Farm"
  Given there is a snippet titled "Member Homepage Welcome"  
  Given I am logged in as an admin
  Given I am on home
  Then I should see "Snippets" within "#manage_farm_links"
  When I follow "Snippets" within "#manage_farm_links"
  Then I should see "snippets"

Scenario: Viewing Snippet List
  Then I should see "snippets"
  And I should see "Member Homepage Welcome"
  And I should not see "Clark Member Homepage Welcome"

Scenario: Viewing a Snippet
  When I follow "Show"
  Then I should see "Member Homepage Welcome"
  When I follow "Snippets List"
  Then I should see "snippets"

Scenario: Editing a Snippet
  When I follow "Edit"
  Then I should see "Editing snippet"
  When I follow "Back"
  Then I should see "snippets"
  When I follow "Edit"
  Then I should see "Editing snippet"
  When I follow "Show"
  Then I should see "Member Homepage Welcome"

Scenario: Updating a Snippet
  When I follow "Edit"
  Then I should see "Editing snippet"
  When I press "Submit"
  Then I should see "Snippet was successfully updated"
  And I should see "Snippet:"

