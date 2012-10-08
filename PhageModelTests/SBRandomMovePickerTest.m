//
//  Created by s.brautaset@london.net-a-porter.com on 30/03/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <SenTestingKit/SenTestingKit.h>
#import "SBRandomMovePicker.h"
#import "SBBoard.h"

@interface SBRandomMovePickerTest : SenTestCase
@end

@implementation SBRandomMovePickerTest

- (void)test {
    SBRandomMovePicker *picker = [[SBRandomMovePicker alloc] init];
    SBBoard *state = [SBBoard board];

    NSCountedSet *moves = [NSCountedSet set];
    for (int i = 0; i < 1000; i++) {
        SBMove *move = [picker moveForState:state];
        STAssertNotNil(move, nil);

        [moves addObject:move];
    }

    STAssertEquals(moves.count, 61u, @"Visits all moves at least once");

    for (id move in moves) {
        STAssertTrue([moves countForObject:move] > 3, @"Each visited move at least 3 times");
    }
}


@end
