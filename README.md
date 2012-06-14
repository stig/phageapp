Phage for iOS
=============

I want to implement the game described here:

http://www.theallseeingi.proboards.com/index.cgi?board=fg&action=print&thread=322

It's currently not available for iOS, nor any other platform, to the
best of my knowledge. There is no trademark issues; its inventor asked
me to implement it, and was happy for me to charge for it.

Key Features
------------

* GameCentre-enabled: Play turn-based games against friends or random opponents.
* Should be universal, i.e. same purchase for iPad & iPhone.

Completed Milestones
--------------------

* GameCenter: Turn Based Match making - find an opponent
* GameCenter: Ability to keep multiple games running at once
* GameCenter: Turn-based game support
* GameCenter: Save game at every step, and resume after re-launch. (Even after logging out and logging in as another user in Game Center.)
* UI (not necessarily pretty) working
* AI player hooked up ("Solitare Mode")

Uncompleted Milestones
----------------------

These are in no particular order, really.

* GameCenter: Determine how to store current Elo rating, since GC scores can only go up. (Two leaderboards? One with positive, and one with negative scores? Accumulate negative scores in one, positive in others. Aggregate across both to get the current score.)
* GameCenter: Ability to show leaderboards
* GameCenter: Ability to unlock / show achievements
  * Novice / Advanced / Master / Grand-Master / Galactic Overlord etc
  * Winning Streak / Short-cut to Looserville
  * Burning midnight oil (midnight - 6am)
* Rules / game guide. Since this is a game nobody is likely to have played before, we need to present the rules
* Localisations
* Polish. It absolutely must look good, but I'm happy about it not being too full-featured.
* Share with Twitter / Facebook / email

Suggested timeline
------------------

* <del>April: rudimentary GameCenter turn-based 2-player play</del>
* <del>May: rudimentary AI 1-player play</del>
* June: Scores & Achievements
* *July: Mostly a  wash-out development-wise due to vacation. Hopefully some user testing?*
* August: Rules / Game guide / Polish / Icons
* September: Polish
* October: 1.0 Release!
* November: 1.1 release: Localisations! (TBD)
* December: 1.2 release: Themes! (TBD)


Hacking
=======

We now rely on OCMock in the tests target. This is in external
dependency, using a git submodule. To pull in the right version, run:

    $ git submodule update --init

Resources
---------
* Beginning Turn-Based Gaming with iOS 5 blog post:
  * http://www.raywenderlich.com/5480/beginning-turn-based-gaming-with-ios-5-part-1
  * http://www.raywenderlich.com/5509/beginning-turn-based-gaming-with-ios-5-part-2
