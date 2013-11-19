Feature: User
  In order to setup PredictionIO
  An user should be created

Scenario: Create user
  Given no user exists yet
  When I create an user with id "1"
  Then there should exist one user

Scenario: Create an user with parameters
  Given no users exist
  When I create a new user with id "1", pio_latitude: "0.2", and pio_longitude: "0.4"
  Then I should have one user created
