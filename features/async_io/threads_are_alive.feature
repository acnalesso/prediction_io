Feature: Threads are alive
  In order to keep getting work pushed onto
  the queue done
  As an exception is raised
  I want my thread pool to be alive

Scenario: Thread Pool
  Given I have "3" threads sleeping
  When 3 exceptions happen
  Then all my threads should be still alive
