*These notes are based in part on [GameKnot][]'s rating FAQ answers.*

[gameknot]: http://gameknot.com/help.pl?q=ratings

# Understanding Phage Scores

## Introduction

Phage uses a relational scoring system. Instead of telling you how well you did in a particular match this system tries to tell you how you rate *compared to your opponents*.

Since you're an unknown quantity when you first start playing we calculate a provisional score for your first 20 matches. We do this by averaging your opponent's score plus/minus a constant K depending on the outcome of the match. K is normally 400, but if your opponent also has a provisional rating we set K to 200.

> **Provisional score example:**
> After three games you've won against someone rated 1340, lost against someone rated 1270 and won against a player provisionally rated 1500. Your own provisional score will then be: ((1340 + 400) + (1270 - 400) + (1500 + 200)) / 3 = 1436.

After you've played 20 matches we switch to use a different formula to calculate your score. We now use the ELO system, originally developed for Chess. New ratings will now be calculated based on the outcome of the game, your current rating, and the rating of your opponent. The formula is such that wins against higher rated players gives you many points, whilst wins against lower ranking players gives you fewer. If you draw you will end up gaining points if your opponent was rated higher than you, and lose points if she was weaker.

## Implementation

Store scores and count of matches in iCloud Key-Value Store.




