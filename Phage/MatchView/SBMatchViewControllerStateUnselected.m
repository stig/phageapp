//
// Created by SuperPappi on 07/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBMatchViewControllerStateUnselected.h"
#import "SBMatchViewControllerStateSelected.h"
#import "SBMatchViewControllerStateHint.h"
#import "SBMatchViewControllerStateDragged.h"
#import "SBPiece.h"
#import "SBLocation.h"

@implementation SBMatchViewControllerStateUnselected

- (void)handleSingleTapWithPiece:(SBPiece *)piece {
    [super handleSingleTapWithPiece:piece];

    if ([self.delegate canCurrentPlayerMovePiece:piece]) {
        SBMatchViewControllerStateSelected *state = [SBMatchViewControllerStateSelected state];
        state.selected = piece;
        [self.delegate transitionToState:state];
    }
}

- (void)handleDoubleTapWithPiece:(SBPiece *)piece {
    [super handleDoubleTapWithPiece:piece];

    if ([self.delegate canCurrentPlayerMovePiece:piece]) {
        SBMatchViewControllerStateHint *state = [SBMatchViewControllerStateHint state];
        state.selected = piece;
        [self.delegate transitionToState:state];
    }
}

- (BOOL)shouldLongPressStartWithPiece:(SBPiece *)piece {
    return [self.delegate canCurrentPlayerMovePiece:piece];
}

- (void)longPressStartedWithPiece:(SBPiece *)piece atLocation:(SBLocation *)location {
    SBMatchViewControllerStateDragged *state = [SBMatchViewControllerStateDragged state];
    state.dragged = piece;
    state.origin = location;
    [self.delegate transitionToState:state];
}

@end