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

@synthesize delegate = _delegate;

- (CGFloat)cellWidthForState:(SBState *)state {
    return self.bounds.size.width / state.columns;
}

- (CGFloat)cellHeightForState:(SBState *)state {
    return self.bounds.size.height / state.rows;
}

- (CGRect)cellRectForState:(SBState *)state {
    return CGRectMake(0, 0, [self cellWidthForState:state], [self cellHeightForState:state]);
}

- (CGPoint)cellPositionForLocation:(SBLocation *)loc inState:(SBState *)state {
    return CGPointMake((loc.column + 0.5) * [self cellWidthForState:state], (loc.row + 0.5) * [self cellHeightForState:state]);
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (!layers) layers = [[NSMutableDictionary alloc] init];

    SBState *state = self.delegate.currentState;

    for (SBPiece *piece in [state.north arrayByAddingObjectsFromArray:state.south]) {

        CALayer *layer = [layers objectForKey:piece];
        if (!layer) {
            layer = [CALayer layer];
            layer.name = [piece description];
            layer.backgroundColor = [UIColor orangeColor].CGColor;
            layer.cornerRadius = 20.0;
            layer.bounds = [self cellRectForState:state];
            [layers setObject:layer forKey:piece];
            [self.layer addSublayer:layer];
        }

        // Animate the piece to its new position
        layer.position = [self cellPositionForLocation:[state locationForPiece:piece] inState:state];
    }

}

@end
