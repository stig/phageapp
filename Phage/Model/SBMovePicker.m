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
    __block NSInteger minScore = INT_MAX;
    __block id bestMove = nil;

    [[state legalMoves] enumerateObjectsUsingBlock:^(id move, NSUInteger idx, BOOL *stop) {
        SBState *successor = [state successorWithMove:move];
        NSUInteger score = [successor legalMoves].count;
        if (score < minScore) {
            minScore = score;
            bestMove = move;
        }
    }];

    return bestMove;
}


@end