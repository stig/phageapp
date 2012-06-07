//
// Created by SuperPappi on 07/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBBoardViewControllerSelectedState.h"
#import "SBPiece.h"

@implementation SBBoardViewControllerSelectedState

@synthesize selected = _selected;

- (void)transitionIn {
    [super transitionIn];
    [self.gridView pickUpPiece:self.selected];
}

- (void)transitionOut {
    [super transitionOut];
    [self.gridView putDownPiece:self.selected];
}

- (void)handleSingleTapWithPiece:(SBPiece *)piece {
    [super handleSingleTapWithPiece:piece];

    if ([self.delegate canCurrentPlayerMovePiece:piece]) {
        SBBoardViewControllerSelectedState *state = [SBBoardViewControllerSelectedState state];
        state.selected = piece;
        [self.delegate transitionToState:state];
    }
}


@end