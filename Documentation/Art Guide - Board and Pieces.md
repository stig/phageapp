Board Artifacts
===============

This attempts to document all the elements that make up a board. For the time being we focus on the board, cells, and pieces. For all such elements we need 4 different versions:

* foo.png
* foo@2x.png
* foo~iPad.png
* foo~iPad@2x.png

Where foo.png is of size NxM, the @2x versions are 2Nx2M.

Board
-----

A square graphic used for background of the playing board. This is square. Should probably contain a grid, or at least hint at a 8-by-8 slots of some kind.

Size: 320x320px.

	board.png

Cell
----

Represents the blocked state of a cell, i.e. that nobody can go there now. It could be a cross, for example. (It's not called simply 'cell.png' because I'm considering adding 'cell-legal-move.png' for when we highlight legal locations a piece can to move to.)

Size: 40x40px.

	cell-blocked.png

Pieces
------

Represents the **unselected** state of a playing piece.

Size: 40x40px.

	piece-north-circle.png
	piece-north-diamond.png
	piece-north-square.png
	piece-north-triangle.png
	piece-south-circle.png
	piece-south-diamond.png
	piece-south-square.png
	piece-south-triangle.png

Additionally we support the *optional* **selected** counterparts:

	piece-north-circle-selected.png
	piece-north-diamond-selected.png
	piece-north-square-selected.png
	piece-north-triangle-selected.png
	piece-south-circle-selected.png
	piece-south-diamond-selected.png
	piece-south-square-selected.png
	piece-south-triangle-selected.png

If this is not present we'll just scale up the piece to indicate selected state.
