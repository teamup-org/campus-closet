Feature: Dashboard and Profile for Donors

As a donor,
I want to be able to manage my listings,
So that I can assess the status of my clothing.

Background: students exist in database
    Given the following emails have an account associated with them:
    | email                 |
    | test_donor@gmail.com  |

Scenario: Logged in donor visits profile page
    Given I am a logged in donor
    When I click on "Donor Dashboard"
    Then I should see "Requests"
    And I should see "Pickups"
    And I should see my contact info

Scenario: Donor editing phone
    Given I am a logged in donor
    And I am on the Dashboard
    When I click on "Edit Profile"
    And I fill in the "Phone" field with "1234567890"
    And I click on "Confirm User Updates"
    Then I should see "1234567890" as my "Phone"

Scenario: Donor editing address
    Given I am a logged in donor
    And I am on the Dashboard
    When I click on "Edit Profile"
    And I fill in the "Address" field with "College Station, TX"
    And I click on "Confirm User Updates"
    Then I should see "College Station, TX" as my "Address"
