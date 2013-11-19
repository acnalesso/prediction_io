Feature: Get an user
  In order to get an already created user
  As I need to perfom some task on this user

Scenario: aget
  Given I have one user created
  When I get user with id "1"
  Then I should have this user
