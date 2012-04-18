//
//  GridView.h
//  Phage
//
//  Created by Stig Brautaset on 04/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class SBState;

@protocol GridViewDelegate
@property(readonly) SBState *currentState;
@end


@interface GridView : UIView {
    @private
    IBOutlet UIImageView *background;
    NSMutableDictionary *layers;
}

@property(weak) IBOutlet id<GridViewDelegate> delegate;
@end
