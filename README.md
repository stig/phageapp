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


"Completed" Milestones
----------------------

* GameCenter:
  * <del>Turn Based Match making - find an opponent</del>
  * <del>Ability to keep multiple games running at once</del>
  * <del>Turn-based game support</del>
  * <del>Save game at every step, and resume after re-launch. (Even after logging out and logging in as another user in Game Center.)</del>

Uncompleted" Milestones
-----------------------

These are in no particular order, really.

* GameCenter
  * Determine how to store current Elo rating, since GC scores can only go up.
    * One suggestion is to use two leaderboards; one with positive, and one with negative scores. Accumulate negative scores in one, positive in others. Aggregate across both to get the current score.
  * Ability to show leaderboards
  * Ability to unlock / show achievements
    * Novice / Advanced / Master / Grand-Master / Galactic Overlord etc
    * Winning Streak / Short-cut to Looserville
* UI (not necessarily pretty) working
* AI player hooked up ("Solitare Mode")
* Rules / game guide. Since this is a game nobody is likely to have played before, we need to present the rules
* Localisations
* Polish. It absolutely must look good, but I'm happy about it not being too full-featured.

Resources
---------
* Beginning Turn-Based Gaming with iOS 5 blog post:
  * http://www.raywenderlich.com/5480/beginning-turn-based-gaming-with-ios-5-part-1
  * http://www.raywenderlich.com/5509/beginning-turn-based-gaming-with-ios-5-part-2


Hacking
=======

We now rely on OCMock in the tests target. This is in external
dependency, using a git submodule. To pull in the right version, run:

    $ git submodule update --init

