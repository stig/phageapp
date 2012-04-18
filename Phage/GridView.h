//
//  GridView.h
//  Phage
//
//  Created by Stig Brautaset on 04/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class SBState;

@protocol GridViewDelegate
@end

@interface GridView : UIView {
    @private
    IBOutlet UIImageView *background;

    CALayer *cellLayer;
    CALayer *pieceLayer;
    NSMutableDictionary *cells;
    NSMutableDictionary *pieces;
    SBState *currentState;
}

@property(weak) IBOutlet id <GridViewDelegate> delegate;

- (void)setState:(SBState *)state;

@end
