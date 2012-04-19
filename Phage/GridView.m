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
#import "SBMove.h"

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
            [layer setValue:loc forKey:@"location"];
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
            layer.cornerRadius = 20.0; // TODO: animate pieces so we can see which is which
            layer.bounds = [self cellRectForState:state];
            [layer setValue:piece forKey:@"piece"];
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

- (CGPoint)pointOfTouch:(NSSet *)touches {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    return point;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    if (![self.delegate isLocalPlayerTurn]) {
        [[[UIAlertView alloc] initWithTitle:@"Patience!" message:@"Wait for your turn.." delegate:self cancelButtonTitle:@"OK, chill" otherButtonTitles:nil] show];
        return;
    }

    CGPoint point = [self pointOfTouch:touches];
    CALayer *layer = [pieceLayer hitTest:point];
    if (layer) {
        NSLog(@"Found layer: %@", layer.name);

        SBPiece *piece = [layer valueForKey:@"piece"];
        if (![[currentState piecesForPlayer:currentState.player] containsObject:piece]) {
            [[[UIAlertView alloc] initWithTitle:@"BEEEP!" message:@"You can't move that piece; it's not yours!" delegate:self cancelButtonTitle:@"OK, just testing.." otherButtonTitles:nil] show];
            return;
        }

        draggingLayer = layer;
        // TODO zoom the layer so it looks like it's picked up
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (draggingLayer)
        draggingLayer.position = [self pointOfTouch:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (draggingLayer) {
        CALayer *cell = [cellLayer hitTest:[self pointOfTouch:touches]];
        NSAssert(cell, @"Should have a cell now");

        SBLocation *loc = [cell valueForKey:@"location"];
        SBPiece *piece = [draggingLayer valueForKey:@"piece"];
        if ([[currentState moveLocationsForPiece:piece] containsObject:loc]) {
            NSLog(@"%@ is a valid move location for %@", loc, piece);
            draggingLayer.position = [self cellPositionForLocation:loc inState:currentState];
            [self.delegate performMove:[[SBMove alloc] initWithPiece:piece to:loc]];

        } else {
            NSLog(@"BEEEP! Illegal move!");
            draggingLayer.position = [self cellPositionForLocation:[currentState locationForPiece:piece]
                                                           inState:currentState];
        }
        draggingLayer = nil;
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (draggingLayer) {
        NSLog(@"touchesCancelled");
        draggingLayer = nil;
    }
}

@end
