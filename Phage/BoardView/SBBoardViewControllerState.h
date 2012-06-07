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
- (void)pickUpPiece:(SBPiece *)piece;
- (void)putDownPiece:(SBPiece *)piece;
- (void)transitionToState:(SBBoardViewControllerState*)state;
@end


@interface SBBoardViewControllerState : NSObject < SBBoardViewDelegate >
@property(weak) id<SBBoardViewControllerStateDelegate> delegate;

+ (id)state;
+ (id)stateWithDelegate:(id <SBBoardViewControllerStateDelegate>)delegate;

- (id)initWithDelegate:(id <SBBoardViewControllerStateDelegate>)delegate;

- (void)transitionIn;
- (void)transitionOut;


@end