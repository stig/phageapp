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
@synthesize state = _state;

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

    if ([_state isEqualToState:state]) {
        NSLog(@"New state is identical to current state");
        return;
    }

    [state enumerateLocationsUsingBlock:^(SBLocation *loc) {
        CAShapeLayer *layer = [cells objectForKey:loc];
        if (!layer) {
            layer = [CAShapeLayer layer];
            layer.name = [loc description];
            layer.bounds = [self cellRectForState:state];
            layer.position = [self cellPositionForLocation:loc inState:state];
            layer.delegate = self;
            [layer setValue:loc forKey:@"location"];
            [cells setObject:layer forKey:loc];
            [cellLayer addSublayer:layer];
        }

        if ([state wasLocationOccupied:loc]) {
            layer.strokeEnd = 1.0;
        } else {
            layer.strokeEnd = 0.0;
        }

        [layer setNeedsDisplay];
    }];

    for (SBPiece *piece in [state.playerOnePieces arrayByAddingObjectsFromArray:state.playerTwoPieces]) {

        CAShapeLayer *layer = [pieces objectForKey:piece];
        if (!layer) {
            layer = [CAShapeLayer layer];
            layer.name = [piece description];
            layer.delegate = piece;
            layer.bounds = [self cellRectForState:state];
            [layer setValue:piece forKey:@"piece"];
            [layer setNeedsDisplay];

            [pieces setObject:layer forKey:piece];
            [pieceLayer addSublayer:layer];

            CATextLayer *textLayer = [CATextLayer layer];
            textLayer.backgroundColor = [UIColor darkGrayColor].CGColor;
            textLayer.foregroundColor = [UIColor whiteColor].CGColor;
            textLayer.contentsScale = [[UIScreen mainScreen] scale];
            textLayer.frame = CGRectMake(layer.bounds.size.width - 14, 0, 14, 14);
            textLayer.fontSize = 14.0;
            textLayer.cornerRadius = 7.0;
            textLayer.alignmentMode = kCAAlignmentCenter;

            [layer addSublayer:textLayer];
            [layer setValue:textLayer forKey:@"movesLeft"];
        }

        ((CATextLayer *)[layer valueForKey:@"movesLeft"]).string = [NSString stringWithFormat:@"%u", [state movesLeftForPiece:piece]];

        // Animate the piece to its new position
        [CATransaction begin];
        [CATransaction setAnimationDuration:1.0f];
        layer.position = [self cellPositionForLocation:[state locationForPiece:piece] inState:state];
        [CATransaction commit];
    }

    legalDestinations = [[NSMutableDictionary alloc] init];
    [state enumerateLegalMovesWithBlock:^(SBMove *move, BOOL *stop) {
        NSMutableSet *dst = [legalDestinations objectForKey:move.piece];
        if (!dst) {
            dst = [NSMutableSet set];
            [legalDestinations setObject:dst forKey:move.piece];
        }
        [dst addObject:move.to];
    }];

    _state = state;
    [self setNeedsDisplay];
}

- (void)drawLayer:(CAShapeLayer *)layer inContext:(CGContextRef)ctx {
    layer.lineWidth = 7.0;
    layer.strokeColor = [UIColor darkGrayColor].CGColor;

    CGRect r = CGRectInset(layer.bounds, 6.0, 6.0);

    CGMutablePathRef path = CGPathCreateMutable();

    CGPathMoveToPoint(path, nil, r.origin.x, r.origin.y);
    CGPathAddLineToPoint(path, nil, r.origin.x + r.size.width, r.origin.y + r.size.width);

    CGPathMoveToPoint(path, nil, r.origin.x, r.origin.y + r.size.width);
    CGPathAddLineToPoint(path, nil, r.origin.x + r.size.height, r.origin.y);

    layer.path = path;
    CGPathRelease(path);
}


#pragma mark GridView Touch

- (CGPoint)pointOfTouch:(NSSet *)touches {
    return [[touches anyObject] locationInView:self];
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
        if (![[_state piecesForPlayer:_state.isPlayerOne] containsObject:piece]) {
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
        SBPiece *piece = [draggingLayer valueForKey:@"piece"];
        CALayer *cell = [cellLayer hitTest:[self pointOfTouch:touches]];
        SBLocation *loc = [cell valueForKey:@"location"];
        if (cell && [[legalDestinations objectForKey:piece] containsObject:loc]) {
            NSLog(@"%@ is a valid move location for %@", loc, piece);
            draggingLayer.position = [self cellPositionForLocation:loc inState:_state];
            [self.delegate performMove:[[SBMove alloc] initWithPiece:piece to:loc]];

        } else {
            NSLog(@"%@ is NOT a valid move location for %@", loc, piece);
            draggingLayer.position = [self cellPositionForLocation:[_state locationForPiece:piece]
                                                           inState:_state];
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
