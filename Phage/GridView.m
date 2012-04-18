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

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        layers = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark -

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

#pragma mark -

- (void)setState:(SBState *)state {

    if ([currentState isEqualToState:state]) {
        NSLog(@"New state is identical to current state");
        return;
    }

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
        [CATransaction begin];
        [CATransaction setAnimationDuration:1.0f];
        layer.position = [self cellPositionForLocation:[state locationForPiece:piece] inState:state];
        [CATransaction commit];
    }

    NSLog(@"Assigning new state to the current state");
    currentState = state;
    [self setNeedsDisplay];
}

@end
