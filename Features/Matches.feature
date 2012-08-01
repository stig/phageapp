Feature: Starting & switching between matches
  In order to play a match against an AI or another human
  As a human player
  I want to start and switch between 1 and 2-player matches

  Scenario: No active match
    Given there is no active matches
    When I launch the game
    Then a new 1-player match should be created automatically
    And I should be told how to start a 2-player match instead
    And I should be told how to view the rules

  Scenario: Resuming most recent active match
    Given there is at least 1 active match
    When I launch the game
    Then the most recently updated match should be resumed

  Scenario: Load finished match
    Given a finished match exists
    When I load a finished match
    Then I should be told that the match is over
    And I should be told the outcome of the match
    And I should not be allowed to perform any moves

  Scenario: Discard finished match
    Given a finished match is loaded
    When I click the "discard" button
    Then the match should be deleted and a new match should be loaded

  Scenario: Discard active match
    Given an active match is loaded
    When I click the "discard" button
    Then I should be asked to confirm that I want to resign the match
    And the match should go to finished state

  Scenario: Resume active matches
    Given at least 1 active match exists
    When I hit the '+' button
    Then I should have the option to resume active matches

  Scenario: Load inactive matches
    Given at least 1 inactive match exists
    When I hit the '+' button
    Then I should have the option to load inactive matches

  Scenario: Start new match
    When I hit the '+' button
    Then I should have the option to create a new 1-player match
    And I should have the option to create a new 2-player match
