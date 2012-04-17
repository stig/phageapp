//
//  GridView.m
//  Phage
//
//  Created by Stig Brautaset on 04/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GridView.h"
#import "SBState.h"
#import "SBLocation.h"

@implementation GridView

@synthesize background = _background;
@synthesize delegate = _delegate;


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    SBState *state = self.delegate.currentState;

    CGRect cell = CGRectMake(0, 0, rect.size.width / state.columns, rect.size.height / state.rows);
    for (SBPiece *p in [state.north arrayByAddingObjectsFromArray:state.south]) {
        SBLocation *loc = [state locationForPiece:p];
        CGRect cellRect = CGRectOffset(cell, loc.column * cell.size.width, loc.row * cell.size.height);
        NSLog(@"Cell rect: %@", NSStringFromCGRect(cellRect));
    }

}

@end
