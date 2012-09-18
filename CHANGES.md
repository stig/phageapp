1.0 beta2 (2012-09-18)
======================

* Highlight possible moves when tapping piece twice.
* Dim the grid a bit to make it less jarring.
* Make the numbers of moves left badge on pieces less pixelated.
* When it's a human's turn:
  a) Only bounce moveable pieces
  b) Dim unmovable pieces
* Update acknowledgements in About screen.
* Add a game over message when a match end as a result of a move being performed.
* Added missing reflections on splash screen and game board.


1.0 beta1 (2012-09-13)
======================

* iPhone 5 support!
* Tweak graphics; fix some grid alignment issues.
* Squashed minor infrastructure issues.


0.7.5 (2012-09-12)
==================

* Improved the "How To Play" screen, notably by getting the objective of the game into it.
* Remove optional ADBannerViewDelegate methods + allow banner view to take over screen.
* Tweaking graphics elements to dim some elements and make others brighter.

0.7.4 (2012-09-10)
==================

* Fixed issue where match could erroneously be reported as a draw, when it was actually won by player 1. (Reported by Avon Ho.)

0.7.3 (2012-09-10)
==================

* Remove TestFlight identification, since it doesn't seem to work anyway (and we can't ship with it).
* Make sure ad banner is not shown when the match view loads, but is shown as a result of ads loading. This should avoid the white rectangle at the bottom of the screen.
* Updated Howto with much better graphics, derived from the pieces in play.


0.7.2 (2012-09-09)
==================

* Hide Ad view when we fail to retrieve ads.
* Slight update to theme (make the pieces bolder).
* Update attributions in About page.


0.7 (2012-09-08)
================

* Change to use black menus, and black background on the board view.
* Add iAd, unobtrusively, to hopefully recover github account fees.

0.6.2 (2012-09-08)
==================

* Added retina display graphics.
* Fixed bug causing support mails going to the wrong address address.
* Fixed a potential memory leak.


0.6 (2012-09-06)
================

This release has been mostly about adding polish. Most importantly, it includes the first iteration of some nice graphics from my lovely and talented wife. Other changes include:

* Bounce human player's pieces to indicate which ones can be moved when it's their turn.
* Indicate by "shuddering" piece when you click a piece that cannot be moved.
* Pulse pieces when they are selected rather than scale them up.
* Display support details in settings screen; click to tweet/email.
* Shorten the time the AI takes to move.


0.5 (2012-08-31)
================

The main focus of this release has been on making the UI "less busy", i.e. removing the clutter of buttons on the main screen. However, there are several other fixes and improvements too:

* Ensure no moves can be made after Game Over. FOR REAL THIS TIME! :-)
* Scale up pieces to indicate selected state rather than show a red background.
* Update the "How to Play" guide with images, and remove obsolete references.
* Improve the forfeit and delete match dialogs, and use different buttons for these actions based on whether the game is in Game Over state or not.
* Turn off rotations in Board Game view as it would obscure part of the board.
* Disable iPad as it has no interface. (Will use pixel doubling instead.)
* Avoid flashing a big cross in each cell on initial match launch.
* When the board appears the pieces glide to their current state from their initial positions, rather than from the top left corner of the board.
* The keyboard no longer obscures editing of player alias.
* Player aliases changes are remembered between launches of the app.
* Do not show finished match section if it is empty.
* Show About screen with acknowledgements (available from Settings).


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
