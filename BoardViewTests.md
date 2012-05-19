# BoardView Behaviours

## When it is NOT my turn

	Given it is NOT my turn
	When I click any piece
	Then the piece should NOT become selected
	And I should be told it is not my turn

## When it IS my turn

	Given it is my turn
	And a piece I own CANNOT be moved
	When I click this piece
	Then it should NOT become selected
	And I should be told the piece cannot be moved

	Given it is my turn
	And a piece I own can be moved
	When I click this piece
	Then it should become selected

	Given it is my turn
	When I click a piece I DON'T own
	Then the piece should NOT become selected
	And I should be told the piece is not mine

	Given it is my turn
	And a piece is selected
	When I click the same piece
	Then the piece should become unselected

	Given it is my turn
	And a piece is selected
	When I click a square that is NOT a legal move
	Then I should be told I cannot move there

	Given it is my turn
	And a piece is selected
	When I click a square that is a legal move
	Then the piece should move there
	And it should no longer be selected
	And it should no longer be my turn
