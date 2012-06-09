//
//  GridView.h
//  Phage
//
//  Created by Stig Brautaset on 04/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class SBState;
@class SBMove;
@class SBLocation;
@class SBPiece;
@class SBCellLayer;
@class SBPieceLayer;

@protocol SBBoardViewDelegate
- (void)handleSingleTapWithPiece:(SBPiece *)piece;
- (void)handleSingleTapWithLocation:(SBLocation *)location;

- (void)handleDoubleTapWithPiece:(SBPiece *)piece;
- (void)handleDoubleTapWithLocation:(SBLocation *)location;

- (BOOL)shouldLongPressStartWithPiece:(SBPiece *)piece;

- (void)longPressStartedWithPiece:(SBPiece *)piece atLocation:(SBLocation *)location;

- (void)longPressEndedAtLocation:(SBLocation *)location;
@end

@interface SBBoardView : UIView

@property(weak) IBOutlet id <SBBoardViewDelegate> delegate;

- (void)layoutForState:(SBState *)state;
- (void)pickUpPiece:(SBPiece *)piece;
- (void)putDownPiece:(SBPiece *)piece;
- (void)movePiece:(SBPiece *)piece toLocation:(SBLocation *)location;
- (void)setCellHighlighted:(BOOL)highlighted atLocation:(SBLocation*)location;

@end
