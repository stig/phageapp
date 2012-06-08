//
// Created by SuperPappi on 07/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBBoardViewControllerUnselectedState.h"
#import "SBBoardViewControllerSelectedState.h"
#import "SBBoardViewControllerHintState.h"

@implementation SBBoardViewControllerUnselectedState

- (void)handleSingleTapWithPiece:(SBPiece *)piece {
    [super handleSingleTapWithPiece:piece];

    if ([self.delegate canCurrentPlayerMovePiece:piece]) {
        SBBoardViewControllerSelectedState *state = [SBBoardViewControllerSelectedState state];
        state.selected = piece;
        [self.delegate transitionToState:state];
    }
}

- (void)handleDoubleTapWithPiece:(SBPiece *)piece {
    [super handleDoubleTapWithPiece:piece];

    if ([self.delegate canCurrentPlayerMovePiece:piece]) {
        SBBoardViewControllerHintState *state = [SBBoardViewControllerHintState state];
        state.selected = piece;
        [self.delegate transitionToState:state];
    }
}

@end