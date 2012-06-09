//
// Created by SuperPappi on 07/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBBoardViewControllerSelectedState.h"
#import "SBPiece.h"
#import "SBBoardViewControllerConfirmState.h"
#import "SBBoardViewControllerHintState.h"
#import "SBBoardViewControllerDraggedState.h"
#import "SBLocation.h"

@implementation SBBoardViewControllerSelectedState

@synthesize selected = _selected;

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToBoardViewControllerSelectedState:other];
}

- (BOOL)isEqualToBoardViewControllerSelectedState:(SBBoardViewControllerSelectedState *)other {
    if (self == other)
        return YES;
    return self.selected == other.selected;
}

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

        if (![self isEqual:state]) {
            [self transitionOut];
            [self.delegate transitionToState:state];
        }
    }
}

- (void)handleDoubleTapWithPiece:(SBPiece *)piece {
    [super handleDoubleTapWithPiece:piece];

    if ([self.delegate canCurrentPlayerMovePiece:piece]) {
        SBBoardViewControllerHintState *state = [SBBoardViewControllerHintState state];
        state.selected = piece;

        if (![self isEqual:state]) {
            [self transitionOut];
            [self.delegate transitionToState:state];
        }
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

- (BOOL)shouldLongPressStartWithPiece:(SBPiece *)piece {
    return [self.delegate canCurrentPlayerMovePiece:piece];
}

- (void)longPressStartedWithPiece:(SBPiece *)piece atLocation:(SBLocation *)location {
    [self transitionOut];
    SBBoardViewControllerDraggedState *state = [SBBoardViewControllerDraggedState state];
    state.dragged = piece;
    state.origin = location;
    [self.delegate transitionToState:state];
}


@end