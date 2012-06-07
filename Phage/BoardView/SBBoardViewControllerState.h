//
// Created by SuperPappi on 07/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "SBBoardView.h"

@class SBBoardViewControllerState;
@class SBPiece;

@protocol SBBoardViewControllerStateDelegate
- (BOOL)canCurrentPlayerMovePiece:(SBPiece *)piece;
- (BOOL)canMovePiece:(SBPiece *)piece toLocation:(SBLocation *)location;
- (SBLocation*)locationOfPiece:(SBPiece *)piece;
- (void)movePiece:(SBPiece *)piece toLocation:(SBLocation *)location;
- (void)transitionToState:(SBBoardViewControllerState*)state;
@end


@interface SBBoardViewControllerState : NSObject < SBBoardViewDelegate >
@property(weak) SBBoardView *gridView;
@property(weak) id<SBBoardViewControllerStateDelegate> delegate;

+ (id)state;

- (void)transitionIn;
- (void)transitionOut;

@end