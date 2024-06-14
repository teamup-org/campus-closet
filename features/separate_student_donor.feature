Feature: Separate student from donor Dashboard

As a user,
I want to be able to have the ability to be both a student and donor
So that to can both upload clothing to donate and request clothing from other donors

Scenario: Fill in Account Creation w/ Donor Field
    Given I do not have an account already, "teststudent2@tamu.edu"
    And I am on the account creation page, "teststudent2@tamu.edu"
    When I enter "1234567890" in "Phone" 
    And I enter "College Station, TX" in "Address"
    And I click on "Donor" checkbox
    And I click on "Save"
    Then I should be put on the homepage
    And I should see "Donor Dashboard" on the navbar

Scenario: User has both student and donor roles
    Given I have an account, "test_student_donor@tamu.edu", with student and donor roles
    And I am on the Login page
    When I click "Login", "test_student_donor@tamu.edu"
    Then I should be logged in
    And I should be put on the homepage
    And I should see "Donor Dashboard" on the navbar
    And I should see "Student Profile" on the navbar

Scenario: Student updates account to be donor
    Given I am a logged in student
    And I do not see "Donor Dashboard" on the navbar
    When I click on "Student Profile"
    And I click on "Edit Account"
    And I click on "Donor" checkbox
    And I click on "Confirm User Updates"
    Then I should see "Donor Dashboard" on the navbar