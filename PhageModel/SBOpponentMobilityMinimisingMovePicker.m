//
//  Created by s.brautaset@london.net-a-porter.com on 30/03/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBOpponentMobilityMinimisingMovePicker.h"
#import "SBMove.h"
#import "SBBoard.h"

@implementation SBOpponentMobilityMinimisingMovePicker

- (SBMove *)moveForState:(SBBoard *)state {
    __block NSInteger minScore = INT_MAX;
    __block id bestMove = nil;

    [state enumerateLegalMovesWithBlock:^(SBMove *move, BOOL *stop) {
        SBBoard *successor = [state successorWithMove:move];
        __block NSUInteger score = 0;
        [successor enumerateLegalMovesWithBlock:^(SBMove *move1, BOOL *stop1) {
            score++;
        }];
        if (score < minScore) {
            minScore = score;
            bestMove = move;
        }
    }];

    return bestMove;
}


@end