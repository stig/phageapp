//
// Created by SuperPappi on 07/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBBoardViewControllerState.h"
#import "SBPiece.h"

@implementation SBBoardViewControllerState

@synthesize delegate = _delegate;
@synthesize gridView = _gridView;


+ (id)state {
    return [[self alloc] init];
}

#pragma mark State Transitions

- (void)transitionIn {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));
}

- (void)transitionOut {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));
}


#pragma mark Board View Delegate

- (void)handleSingleTapWithPiece:(SBPiece *)piece {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));
}

- (void)handleSingleTapWithLocation:(SBLocation *)location {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));
}

- (void)handleDoubleTapWithPiece:(SBPiece *)piece {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));
}

- (void)handleDoubleTapWithLocation:(SBLocation *)location {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));
}

- (BOOL)shouldLongPressStartWithPiece:(SBPiece *)piece {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));
    return NO;
}

- (void)longPressStartedWithPiece:(SBPiece *)piece {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));
}

- (void)longPressEndedWithPiece:(SBPiece *)piece atLocation:(SBLocation *)location {
    @throw @"Should not get here";
}

- (BOOL)shouldLongPressStartWithLocation:(SBLocation *)location {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));
    return NO;
}

- (void)longPressStartedWithLocation:(SBLocation *)location {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));
}

@end