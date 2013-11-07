Feature: User
  In order to setup PredictionIO
  An user should be created

Scenario: Create user
  Given no user exists yet
  When I create a user with id "1" 
  Then there should exist one user
