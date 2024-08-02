Feature: Account Creation

As a user,
I want to be able to view details about an item,
So that I can understand what clothes I want.

Background:

    Given the following emails have an account associated with them:
    | email                 |
    | test_donor@gmail.com  |
    | test_student@tamu.edu |


Scenario: User logs in with TAMU email
    Given I have an account, "test_student@tamu.edu"
    And I am on the Login page
    When I click "Login", "test_student@tamu.edu"
    Then I should be logged in
    And I should be put on the homepage

Scenario: User logs in with gmail
    Given I have an account, "test_donor@gmail.com"
    And I am on the Login page
    When I click "Login", "test_donor@gmail.com"
    Then I should be logged in
    Then I should be put on the homepage

Scenario: User logs in with TAMU email for first time
    Given I do not have an account already, "teststudent2@tamu.edu"
    And I am on the Login page
    When I click "Login", "teststudent2@tamu.edu"
    Then I should be put on the account creation page

Scenario: User logs in with gmail for first time
    Given I do not have an account already, "testdonor2@gmail.com"
    And I am on the Login page
    When I click "Login", "testdonor2@gmail.com"
    Then I should be put on the account creation page

Scenario: Fill in Account Creation
    Given I do not have an account already, "teststudent2@tamu.edu"
    And I am on the account creation page, "teststudent2@tamu.edu"
    When I enter "1234567890" in "Phone" 
    And I enter "College Station, TX" in "Address"
    And I click on "Sign Up"
    Then I should be put on the homepage