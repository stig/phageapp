//
// Created by SuperPappi on 08/10/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBRandomMovePicker.h"
#import "SBBoard.h"

@implementation SBRandomMovePicker

// Private "Spare" parts doesn't know what he's doing. He just picks a move at random.
- (id)moveForState:(id<SBGameTreeNode>)state {
    __block NSInteger max = INT_MIN;
    __block id bestMove = nil;

    [(SBBoard*)state enumerateLegalMovesWithBlock:^(SBMove *move, BOOL *stop) {
        NSInteger rnd = arc4random_uniform(1000);
        if (rnd > max) {
            max = rnd;
            bestMove = move;
        }
    }];

    return bestMove;
}


@end