//
// Created by SuperPappi on 07/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBBoardViewControllerSelectedState.h"
#import "SBPiece.h"
#import "SBBoardViewControllerConfirmState.h"

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

        [self transitionOut];
        [self.delegate transitionToState:state];
    }
}

- (void)handleSingleTapWithLocation:(SBLocation *)location {
    [super handleSingleTapWithLocation:location];

    if ([self.delegate canMovePiece:self.selected toLocation:location]) {
        SBBoardViewControllerConfirmState *state = [SBBoardViewControllerConfirmState state];
        state.selected = self.selected;
        state.destination = location;
        state.previousState = self;
        [self.delegate transitionToState:state];
    } else {
        NSLog(@"Cannot move %@ to %@", self.selected, location);
    }

}


@end