0.4 (2012-08-26)
================

*Important Note*

In the interest of getting the game out the door I've decided to cut
networking (i.e. Game Center), high scores and achievements from the
initial version. If you're in the middle of a networked match you may
want to finish it before upgrading to this version.

Improvements:

* We now allow multiple matches against the AI to go on at the same time, as well as multiple matches against another human opponent.
* Now display player alias
* Simplified a lot of the drawing code, by using higher-level APIs. This should hopefully result in fixing the bug that allowed moves after GAME OVER.
* Show version and build number in the app enhancement
* Add TestFlight checkpoints in sensible places
* There is now some explanatory text at GAME OVER

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
