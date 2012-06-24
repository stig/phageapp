//
// Created by SuperPappi on 07/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "SBMatchView.h"

@class SBMatchViewControllerState;
@class SBPiece;

@protocol SBMatchViewControllerStateDelegate
- (BOOL)canCurrentPlayerMovePiece:(SBPiece *)piece;
- (BOOL)canMovePiece:(SBPiece *)piece toLocation:(SBLocation *)location;
- (SBLocation*)locationOfPiece:(SBPiece *)piece;
- (void)movePiece:(SBPiece *)piece toLocation:(SBLocation *)location;
- (void)transitionToState:(SBMatchViewControllerState *)state;
- (void)setLegalDestinationsForPiece:(SBPiece *)piece highlighted:(BOOL)highlighted;
@end


@interface SBMatchViewControllerState : NSObject <SBMatchViewDelegate>
@property(weak) SBMatchView *gridView;
@property(weak) id<SBMatchViewControllerStateDelegate> delegate;

+ (id)state;

- (void)transitionIn;
- (void)transitionOut;

@end