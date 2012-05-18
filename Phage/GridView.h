//
//  GridView.h
//  Phage
//
//  Created by Stig Brautaset on 04/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class SBState;
@class SBMove;

@protocol GridViewDelegate
- (void)performMove:(SBMove*)move;
- (BOOL)isLocalPlayerTurn;
@end

@interface GridView : UIView

@property(weak) IBOutlet id <GridViewDelegate> delegate;

@property(strong, nonatomic) SBState *state;

@end
