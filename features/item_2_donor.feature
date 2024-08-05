Feature: Assign Item to Donor in Creation

As a donor,
I want to be able to create an item assigned with my account,
So that I can post an item and a user can request it from me.

Background: students exist in database
    Given the following emails have an account associated with them:
    | email                 |
    | test_donor@gmail.com  |

    Given the following items exist:
    | color     | type       | Description         | Gender       | Size  | Condition  | Status     | 
    | black     | shirt      | black shirt         | Male         | M     | Used       | Available  | 
    | red       | pants      | red pants           | Female       | L     | Unused     | Available  |
    | blue      | sweater    | blue sweater        | Male         | S     | Used       | Available  |
    | brown     | belt       | brown belt          | Female       | M     | Unused     | Available  |
    

Scenario: Donor creates a shirt item
    Given I am a logged in donor
    And I am on the items page
    And I am on the donor dashboard
    When I click on "Add New Item"
    And I am on the new item page
    And I fill in "color" with "blue"
    And I fill in "type" with "shirt"
    And I fill in description with "blue shirt"
    And I fill in "gender" with "Male"
    And I fill in "size" with "M"
    And I fill in "condition" with "Used"
    And I include a picture
    And I click on "Create Item"
    Then I should be on a new item page
    And the item should be marked as donated by me


Scenario: Donor creates a pants item
    Given I am a logged in donor
    And I am on the homepage
    And I am on the donor dashboard
    When I click on "Add New Item"
    And I fill in "color" with "blue"
    And I fill in "type" with "pants"
    And I fill in description with "blue pants"
    And I fill in "gender" with "Male"
    And I fill in "size" with "M"
    And I fill in "condition" with "Used"
    And I include a picture
    And I fill in "type" with "pants"
    And I click on "Create Item"
    Then I should be on a new item page
    And the item should be marked as donated by me


Scenario: Donor cancel's item creation
    Given I am a logged in donor
    And I am on the homepage
    And I am on the donor dashboard
    When I click on "Add New Item"
    And I am on the new item page
    And I fill in "type" with "shirt"
    And I click on "Home"
    Then I should return back to the homepage