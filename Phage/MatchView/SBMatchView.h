//
//  GridView.h
//  Phage
//
//  Created by Stig Brautaset on 04/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class SBBoard;
@class SBMove;
@class SBLocation;
@class SBPiece;
@class SBCellLayer;
@class SBPieceLayer;

@protocol SBMatchViewDelegate
- (void)handleSingleTapWithPiece:(SBPiece *)piece;
- (void)handleSingleTapWithLocation:(SBLocation *)location;

- (void)handleDoubleTapWithPiece:(SBPiece *)piece;
- (void)handleDoubleTapWithLocation:(SBLocation *)location;

- (BOOL)shouldLongPressStartWithPiece:(SBPiece *)piece;

- (void)longPressStartedWithPiece:(SBPiece *)piece atLocation:(SBLocation *)location;

- (void)longPressEndedAtLocation:(SBLocation *)location;

- (NSString*)turnsLeftForPiece:(SBPiece*)piece;
@end

@interface SBMatchView : UIView

@property(weak) IBOutlet id <SBMatchViewDelegate> delegate;

- (void)setLocation:(SBLocation *)loc blocked:(BOOL)blocked;

- (void)layoutForBoard:(SBBoard *)state;
- (void)pickUpPiece:(SBPiece *)piece;
- (void)putDownPiece:(SBPiece *)piece;

- (void)movePiece:(SBPiece *)piece toLocation:(SBLocation *)location completionHandler:(void (^)(NSError *error))block;
- (void)setCellHighlighted:(BOOL)highlighted atLocation:(SBLocation*)location;

@end
