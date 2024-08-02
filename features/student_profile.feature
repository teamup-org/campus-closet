Feature: Profile Page for Students

As a student,
I would like to be able to view and edit my profile page
including location, name, etc. and view my orders
So I can book and view my orders

Background: students exist in database
    Given the following emails have an account associated with them:
    | email                 |
    | test_student@tamu.edu |

Scenario: Logged in student visits profile page
    Given I am a logged in student
    When I click on "Student Profile"
    Then I should see "Requests"
    And I should see "Pickups"
    And I should see my contact info

Scenario: Student editing address
    Given I am a logged in student
    And I am on the Profile Page
    When I click on "Edit Profile"
    And I fill in the "Address" field with "College Station, TX"
    And I click on "Confirm User Updates"
    Then I should see "College Station, TX" as my "Address"

Scenario: Student editing phone
    Given I am a logged in student
    And I am on the Profile Page
    When I click on "Edit Profile"
    And I fill in the "Phone" field with "1234567890"
    And I click on "Confirm User Updates"
    Then I should see "1234567890" as my "Phone"
  
