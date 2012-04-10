Phage for iOS
=============

I want to implement the game described here:

http://www.theallseeingi.proboards.com/index.cgi?board=fg&action=print&thread=322

* It's currently not available for iOS, to the best of my knowledge.
* There is no trademark issues; its inventor asked me to implement it, and was happy for me to charge for it.

Features
--------

* Single-player mode: Simple AI opponent
* Two-player mode: GameCentre-based. Turn-based games against random opponents / friends

* Universal (iPad / iPhone)
  * We can focus on either iPhone or iPad first for v1.0 if necessary

* Keep multiple games going at the same time?

Milestones
----------

These are in no particular order, really. Apart from the last.

* GameCentre support
  * Determine how to store current Elo rating, since GC scores can only go up.
    * One suggestion is to use two leaderboards; one with positive, and one with negative scores. Accumulate negative scores in one, positive in others. Aggregate across both to get the current score.
  * Turn Based Match making - find an opponent
  * Ability to keep multiple games running at once
  * Turn-based game support
  * Ability to show leaderboards
  * Ability to unlock / show achievements
    * Novice / Advanced / Master / Grand-Master / Galactic Overlord etc
    * Winning Streak / Short-cut to Looserville
* UI (not necessarily pretty) working
* AI player hooked up ("Solitare Mode")
* Rules / game guide. Since this is a game nobody is likely to have played before, we need to present the rules
* Localisations
* Save game at every step, and resume after re-launch
  * Even after logging out and logging in as another user in Game Center!
* Polish. It absolutely must look good, but I'm happy about it not being too full-featured.

