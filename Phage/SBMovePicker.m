//
//  Created by s.brautaset@london.net-a-porter.com on 30/03/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBMovePicker.h"
#import "SBMove.h"
#import "SBState.h"
#import "SBPlayer.h"


@implementation SBMovePicker

- (SBMove *)optimalMoveForState:(SBState *)state withPlayer:(SBPlayer*)player {

    NSArray *moves = [state legalMovesForPlayer:player];

    SBPlayer *opponent = [player opponent];

    NSMutableDictionary *scores = [[NSMutableDictionary alloc] initWithCapacity:moves.count];
    for (SBMove *move in moves) {
        SBState *successor = [state successorWithMove:move];
        NSUInteger score = [successor legalMovesForPlayer:opponent].count;
        [scores setObject:[NSNumber numberWithUnsignedInteger:score] forKey:move];
    }

    NSArray *keysSortedByValue = [scores keysSortedByValueUsingSelector:@selector(compare:)];

    // Return the move which leaves our opponent with the lowest number of moves on her turn
    return [keysSortedByValue objectAtIndex:0];
}


@end