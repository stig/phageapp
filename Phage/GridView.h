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

@protocol GridViewDelegate
- (BOOL)canCurrentPlayerMovePiece:(SBPiece*)piece;
- (BOOL)canMovePiece:(SBPiece*)piece toLocation:(SBLocation*)location;
- (void)movePiece:(SBPiece*)piece toLocation:(SBLocation*)location;
- (BOOL)isLocalPlayerTurn;
@end

@interface GridView : UIView

@property(weak) IBOutlet id <GridViewDelegate> delegate;

- (void)layoutForState:(SBState*)state;

@end
