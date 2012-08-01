Feature: Performing moves
  In order to be able to finish a match
  As a human player
  I want the ability to take turn in a match

  Scenario: Cannot select piece for move when not my turn
	Given it is NOT my turn
	When I click any piece
	Then the piece should NOT become selected

  Scenario: Attempt to select piece with no legal moves
	Given it is my turn
	And a piece I own CANNOT be moved
	When I click this piece
	Then it should NOT become selected
	And I should be told the piece cannot be moved

  Scenario: Select piece for move
	Given it is my turn
	And a piece I own can be moved
	When I click this piece
	Then it should become selected

  Scenario: Tap piece I don't own
	Given it is my turn
	When I click a piece I DON'T own
	Then the piece should NOT become selected
	And I should be told the piece is not mine

  Scenario: Unselect already selected piece
	Given it is my turn
	And a piece is selected
	When I click the same piece
	Then the piece should become unselected

  Scenario: Tap illegal destination for selected piece
	Given it is my turn
	And a piece is selected
	When I click a square that is NOT a legal move
	Then I should be told I cannot move there

  Scenario: Move selected piece to legal destination
	Given it is my turn
	And a piece is selected
	When I click a square that is a legal move
	Then the piece should move there
	And it should no longer be selected
	And it should no longer be my turn

  Scenario: Perform move to end match
    Given I can perform a move
    And my opponent cannot
    When I perform a move
    Then the match should end
    And I should be told the outcome of the match

  Scenario: Loading 1-player match when it's AIs turn
    Given a 1-player match exists
    When the match is loaded
    Then the AI player should move automatically

  Scenario: AI performing move after human in 1-player match
    Given a 1-player match is in play
    When a human performs their move
    And the game is not finished
    Then the AI player should perform a move automatically
