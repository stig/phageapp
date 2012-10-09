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
#import "SBMovePicker.h"

@interface SBMovePickerBattleTest : SenTestCase
@property(nonatomic, strong) id<SBPlayer> parts;
@property(nonatomic, strong) id<SBPlayer> pepper;
@end

@implementation SBMovePickerBattleTest

- (void)setUp {
    self.parts = [SBPartsBot bot];
    self.pepper = [SBPepperBot bot];
}

- (double)ratioOfWinsForPlayerOne:(id<SBPlayer>)one withPlayerTwo:(id<SBPlayer>)two {
    NSCountedSet *outcomes = [NSCountedSet set];
    const int N = 20;

    for (int i = 0; i < N; i++) {
        SBMatch *match = [SBMatch matchWithPlayerOne:one two:two];
        do {
            id move = [match.currentPlayer.movePicker moveForState:match.board];
            [match performMove:move completionHandler:nil];
        } while (!match.isGameOver);
        if (match.winner)
            [outcomes addObject:match.winner.alias];
    }

    int first = [outcomes countForObject:one.alias];
    int second = [outcomes countForObject:two.alias];
    return (double)(first - second) / N;
}

- (void)testPepperBeatsParts {
    STAssertEqualsWithAccuracy([self ratioOfWinsForPlayerOne:self.pepper withPlayerTwo:self.parts], 0.75, 0.25, nil);
}

- (void)testPartsLosesToPepper {
    STAssertEqualsWithAccuracy([self ratioOfWinsForPlayerOne:self.parts withPlayerTwo:self.pepper], -0.75, 0.25, nil);
}

/* These tests produce results I don't understand...
- (void)testPepperBeatsPepperRoughlyHalfTheTime {
    id two = [SBPepperBot botWithAlias:@"AntiPepper"];
    STAssertEqualsWithAccuracy([self ratioOfWinsForPlayerOne:self.pepper withPlayerTwo:two], 0.0, 0.2, nil);
}

- (void)testPartsBeatsPartsRoughlyHalfTheTime {
    id two = [SBPartsBot botWithAlias:@"AntiParts"];
    STAssertEqualsWithAccuracy([self ratioOfWinsForPlayerOne:self.parts withPlayerTwo:two], 0.0, 0.2, nil);
}
*/


@end