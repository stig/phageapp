//
// Created by SuperPappi on 10/09/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//



#import <SenTestingKit/SenTestingKit.h>
#import "SBMatch.h"
#import "SBPlayer.h"
#import "SBMove.h"

@interface SBMatchIntegrationTest : SenTestCase
@end

@implementation SBMatchIntegrationTest {
    SBMatch *match;
    SBPlayer *one;
    SBPlayer *two;
}

- (void)setUp {
    one = [SBPlayer playerWithAlias:@"one"];
    two = [SBPlayer playerWithAlias:@"two"];
    match = [SBMatch matchWithPlayerOne:one two:two];
}

- (void)testRun {
    NSArray *moveHistory = @[
    @[@[@5,@6],@[@5,@2]],
    @[@[@4,@2],@[@2,@4]],
    @[@[@1,@4],@[@1,@3]],
    @[@[@6,@3],@[@6,@7]],
    @[@[@3,@5],@[@4,@4]],
    @[@[@6,@7],@[@7,@6]],
    @[@[@5,@2],@[@7,@2]],
    @[@[@2,@4],@[@3,@3]],
    @[@[@1,@3],@[@2,@2]],
    @[@[@2,@1],@[@7,@1]],
    @[@[@7,@2],@[@6,@2]],
    @[@[@7,@1],@[@6,@1]],
    @[@[@4,@4],@[@5,@5]],
    @[@[@6,@1],@[@3,@1]],
    @[@[@2,@2],@[@1,@1]],
    @[@[@7,@6],@[@6,@6]],
    @[@[@1,@1],@[@1,@0]],
    @[@[@6,@6],@[@6,@4]],
    @[@[@5,@5],@[@3,@7]],
    @[@[@0,@0],@[@0,@1]],
    @[@[@3,@7],@[@0,@4]],
    @[@[@6,@4],@[@5,@3]],
    @[@[@1,@0],@[@4,@0]],
    @[@[@3,@1],@[@4,@1]],
    @[@[@4,@0],@[@5,@1]],
    @[@[@5,@3],@[@4,@3]],
    @[@[@0,@4],@[@1,@5]],
    @[@[@4,@3],@[@3,@2]],
    @[@[@5,@1],@[@5,@0]],
    @[@[@0,@1],@[@0,@2]],
    @[@[@1,@5],@[@0,@6]],
    @[@[@0,@2],@[@1,@2]],
    @[@[@0,@6],@[@1,@7]]
    ];

    for (NSArray *move in moveHistory) {
        STAssertFalse(match.isGameOver, nil);
        [match performMove:[SBMove moveFromPropertyList:move] completionHandler:nil];
        NSLog(@"%@", match);
    }

    STAssertTrue(match.isGameOver, nil);
    STAssertEqualObjects(one.alias, match.winner.alias, nil);
}


@end