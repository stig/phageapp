//
//  GridView.h
//  Phage
//
//  Created by Stig Brautaset on 04/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBBoardViewState.h"

@class SBState;
@class SBMove;
@class SBLocation;
@class SBPiece;
@class SBCellLayer;
@class SBPieceLayer;
@class SBBoardViewAbstractState;

@protocol SBBoardViewDelegate
- (void)handleSingleTapWithPiece:(SBPiece *)piece;
- (void)handleSingleTapWithLocation:(SBLocation *)location;

- (void)handleDoubleTapWithPiece:(SBPiece *)piece;
- (void)handleDoubleTapWithLocation:(SBLocation *)location;

- (BOOL)shouldLongPressStartWithPiece:(SBPiece *)piece;
- (void)longPressStartedWithPiece:(SBPiece *)piece;

- (BOOL)shouldLongPressStartWithLocation:(SBLocation *)location;
- (void)longPressStartedWithLocation:(SBLocation *)location;

- (BOOL)canCurrentPlayerMovePiece:(SBPiece*)piece;
- (BOOL)canMovePiece:(SBPiece*)piece toLocation:(SBLocation*)location;
- (void)movePiece:(SBPiece*)piece toLocation:(SBLocation*)location;
@end

@interface SBBoardView : UIView < SBBoardViewStateDelegate >
@property(strong) id<SBBoardViewState> state;
@property(strong) CALayer *cellLayer;
@property(strong) CALayer *pieceLayer;

@property(weak) IBOutlet id <SBBoardViewDelegate> delegate;

- (void)layoutForState:(SBState *)state state:(id <SBBoardViewState>)boardViewState;

@end
