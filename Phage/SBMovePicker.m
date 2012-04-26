//
//  Created by s.brautaset@london.net-a-porter.com on 30/03/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBMovePicker.h"
#import "SBMove.h"
#import "SBState.h"

@implementation SBMovePicker

- (SBMove *)moveForState:(SBState *)state {
    NSArray *moves = [state legalMoves];

    NSMutableDictionary *scores = [[NSMutableDictionary alloc] initWithCapacity:moves.count];
    for (SBMove *move in moves) {
        SBState *successor = [state successorWithMove:move];
        NSUInteger score = [successor legalMoves].count;
        [scores setObject:[NSNumber numberWithUnsignedInteger:score] forKey:move];
    }

    NSArray *keysSortedByValue = [scores keysSortedByValueUsingSelector:@selector(compare:)];

    // Return the move which leaves our opponent with the lowest number of moves on her turn
    return [keysSortedByValue objectAtIndex:0];
}


@end