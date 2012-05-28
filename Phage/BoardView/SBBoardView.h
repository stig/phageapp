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
- (BOOL)canCurrentPlayerMovePiece:(SBPiece*)piece;
- (BOOL)canMovePiece:(SBPiece*)piece toLocation:(SBLocation*)location;
- (void)movePiece:(SBPiece*)piece toLocation:(SBLocation*)location;
- (BOOL)isLocalPlayerTurn;
@end

@interface SBBoardView : UIView < SBBoardViewStateDelegate >
@property(strong) id<SBBoardViewState> state;
@property(strong) CALayer *cellLayer;
@property(strong) CALayer *pieceLayer;

@property(weak) IBOutlet id <SBBoardViewDelegate> delegate;

- (void)layoutForState:(SBState*)state;

@end
