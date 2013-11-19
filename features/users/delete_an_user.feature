Feature: Delete an user
  In order to get an already created user
  As I need to perfom some task on this user

Scenario: adelete
  Given I have an user created
  When I delete user with id "3"
  Then I should not have user with id 3
