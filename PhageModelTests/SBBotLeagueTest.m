//
// Created by SuperPappi on 09/10/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <SenTestingKit/SenTestingKit.h>
#import "SBPlayer.h"
#import "SBPartsBot.h"
#import "SBPepperBot.h"
#import "SBMatch.h"
#import "SBCarrotBot.h"

@interface SBBotLeagueTest : SenTestCase
@end

@implementation SBBotLeagueTest

- (void)test {
    const int N = 5;

    id<SBPlayer> parts = [SBPartsBot bot];
    id<SBPlayer> pepper = [SBPepperBot bot];
    id<SBPlayer> coleslaw = [SBCarrotBot bot];

    NSArray *players = @[parts, pepper, coleslaw];
    NSCountedSet *outcomes = [NSCountedSet set];

    for (int i = 0; i < N ; i++) {
        for (id a in players) {
            for (id b in players) {
                if (a == b) continue;
                [self playA:a andB:b result:outcomes];
            }
        }
    }

    // Everyone has played everyone else both as player 1 and player 2;
    // time to tally up the scores.
    STAssertTrue([outcomes countForObject:pepper] > [outcomes countForObject:parts], @"%@", outcomes);
    STAssertTrue([outcomes countForObject:coleslaw] > [outcomes countForObject:pepper], @"%@", outcomes);
}

- (void)playA:(id)a andB:(id)b result:(NSCountedSet*)outcomes {
    SBMatch *match = [SBMatch matchWithPlayerOne:a two:b];
    do {
        id move = [match.currentPlayer.movePicker moveForState:(id<SBGameTreeNode>)match.board];
        [match performMove:move completionHandler:nil];
    } while (!match.isGameOver);
    if (match.winner)
        [outcomes addObject:match.winner];
}

@end