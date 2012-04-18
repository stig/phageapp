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
        pieces = [[NSMutableDictionary alloc] init];
        cells = [[NSMutableDictionary alloc] init];

        cellLayer = [[CALayer alloc] init];
        pieceLayer = [[CALayer alloc] init];

        [self.layer addSublayer:cellLayer];
        [self.layer addSublayer:pieceLayer];
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

    [state enumerateLocationsUsingBlock:^(SBLocation *loc) {
        CALayer *layer = [cells objectForKey:loc];
        if (!layer) {
            layer = [CALayer layer];
            layer.name = [loc description];
            layer.bounds = [self cellRectForState:state];
            layer.borderWidth = 1.0f;
            layer.position = [self cellPositionForLocation:loc inState:state];
            [cells setObject:layer forKey:loc];
            [cellLayer addSublayer:layer];
        }
        layer.borderColor = ([state isPreviouslyOccupied:loc]
                ? [UIColor redColor]
                : [UIColor greenColor]).CGColor;
        [layer setNeedsDisplay];
    }];

    for (SBPiece *piece in [state.north arrayByAddingObjectsFromArray:state.south]) {

        CALayer *layer = [pieces objectForKey:piece];
        if (!layer) {
            layer = [CALayer layer];
            layer.name = [piece description];
            layer.backgroundColor = [UIColor orangeColor].CGColor;
            layer.cornerRadius = 20.0;
            layer.bounds = [self cellRectForState:state];
            [pieces setObject:layer forKey:piece];
            [pieceLayer addSublayer:layer];
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

#pragma mark GridView Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if ([touches count] == 1) {
        UITouch *touch = [touches anyObject];
        CGPoint point = [touch locationInView:self];
//        point = [self convertPoint:point toView:nil];

        CALayer *layer = [pieceLayer hitTest:point];
        if (layer)
            NSLog(@"Found layer: %@", layer.name);

        layer = [cellLayer hitTest:point];
        if (layer)
            NSLog(@"Found layer: %@", layer.name);
    }
}


@end
