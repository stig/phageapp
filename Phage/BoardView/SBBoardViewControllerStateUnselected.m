//
// Created by SuperPappi on 07/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBBoardViewControllerStateUnselected.h"
#import "SBBoardViewControllerStateSelected.h"
#import "SBBoardViewControllerStateHint.h"
#import "SBBoardViewControllerStateDragged.h"
#import "SBPiece.h"
#import "SBLocation.h"

@implementation SBBoardViewControllerStateUnselected

- (void)handleSingleTapWithPiece:(SBPiece *)piece {
    [super handleSingleTapWithPiece:piece];

    if ([self.delegate canCurrentPlayerMovePiece:piece]) {
        SBBoardViewControllerStateSelected *state = [SBBoardViewControllerStateSelected state];
        state.selected = piece;
        [self.delegate transitionToState:state];
    }
}

- (void)handleDoubleTapWithPiece:(SBPiece *)piece {
    [super handleDoubleTapWithPiece:piece];

    if ([self.delegate canCurrentPlayerMovePiece:piece]) {
        SBBoardViewControllerStateHint *state = [SBBoardViewControllerStateHint state];
        state.selected = piece;
        [self.delegate transitionToState:state];
    }
}

- (BOOL)shouldLongPressStartWithPiece:(SBPiece *)piece {
    return [self.delegate canCurrentPlayerMovePiece:piece];
}

- (void)longPressStartedWithPiece:(SBPiece *)piece atLocation:(SBLocation *)location {
    SBBoardViewControllerStateDragged *state = [SBBoardViewControllerStateDragged state];
    state.dragged = piece;
    state.origin = location;
    [self.delegate transitionToState:state];
}

@end