0.4 (2012-06-??)
================

* Double-tap to show hints rather than the previous "tap twice" behaviour.
* Long press pieces (tap and hold for 0.5s) to select before dragging.
* Scale up selected/dragged pieces to suggest them being "picked up" off the board.
* Send logs to TestFlight to aid debugging.
* Add TestFlight Checkpoints.
* Should no longer be able to perform moves after GAME OVER.

0.3.1 (2012-06-01)
==================

Fixed bugs:

* Disallow moves after GameOver has been reached.
* Only enable forfeit button when it's your turn.
* Enable forfeit button on iPad.
* Perform moves immediately if you turn off move confirmations.

0.3 (2012-05-29)
================

* Ask user for confirmation to avoid accidental moves.
* Allow turning said move confirmations off, as they get tedious after a while.
* Allow forfeiting a match.
* Updated the "how to play" document.
* Move the board to the top of the window.
* Fix an issue where one player games would occasionally get into an inconsistent state.
* Added in the self-links for when selection passes from one piece to another.
* Added TestFlight SDK for better crash reports and tester analysis.
* Initial iPad UI.


0.2 (2012-05-23)
================

* Tap to select / tap destination to move
* Tap selected piece again to highlight legal destinations for that move
* Save state of 1-player games
* Gently pulse selected pieces
