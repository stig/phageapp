//
// Created by SuperPappi on 07/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBBoardViewControllerState.h"
#import "SBPiece.h"
#import "SBLocation.h"

@implementation SBBoardViewControllerState

@synthesize delegate = _delegate;
@synthesize gridView = _gridView;


+ (id)state {
    return [[self alloc] init];
}

#pragma mark State Transitions

- (void)transitionIn {}

- (void)transitionOut {}


#pragma mark Board View Delegate

- (void)handleSingleTapWithPiece:(SBPiece *)piece {}

- (void)handleSingleTapWithLocation:(SBLocation *)location {}

- (void)handleDoubleTapWithPiece:(SBPiece *)piece {}

- (void)handleDoubleTapWithLocation:(SBLocation *)location {}

- (BOOL)shouldLongPressStartWithPiece:(SBPiece *)piece {
    return NO;
}

- (void)longPressStartedWithPiece:(SBPiece *)piece atLocation:(SBLocation *)location {}

- (void)longPressEndedAtLocation:(SBLocation *)location {
    @throw @"Should not get here";
}

@end