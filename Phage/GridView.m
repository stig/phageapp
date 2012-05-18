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

@implementation GridView {
    CALayer *draggingLayer;
    CALayer *cellLayer;
    CALayer *pieceLayer;
    NSMutableDictionary *cells;
    NSMutableDictionary *pieces;

    NSUInteger columns;
    NSUInteger rows;
}

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

#pragma mark Cell calculations

- (CGFloat)cellWidth {
    return self.bounds.size.width / columns;
}

- (CGFloat)cellHeight {
    return self.bounds.size.height / rows;
}

- (CGRect)cellRect {
    return CGRectMake(0, 0, [self cellWidth], [self cellHeight]);
}

- (CGPoint)cellPositionForLocation:(SBLocation *)loc {
    return CGPointMake((loc.column + 0.5) * self.cellWidth, (loc.row + 0.5) * self.cellHeight);
}

#pragma mark -

- (void)layoutForState:(SBState *)state {
    rows = state.rows;
    columns = state.columns;

    [state enumerateLocationsUsingBlock:^(SBLocation *loc) {
        CAShapeLayer *layer = [cells objectForKey:loc];
        if (!layer) {
            layer = [CAShapeLayer layer];
            layer.name = [loc description];
            layer.bounds = [self cellRect];
            layer.position = [self cellPositionForLocation:loc];
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
            layer.bounds = [self cellRect];
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
        layer.position = [self cellPositionForLocation:[state locationForPiece:piece]];
        [CATransaction commit];
    }

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

        if (![self.delegate canCurrentPlayerMovePiece:[layer valueForKey:@"piece"]]) {
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
        if (cell && [self.delegate canMovePiece:piece toLocation:loc]) {
            NSLog(@"%@ can be moved to %@", piece, loc);
            draggingLayer.position = [self cellPositionForLocation:loc];
            [self.delegate movePiece:piece toLocation:loc];

        } else {
            NSLog(@"%@ is NOT a valid move location for %@", loc, piece);
            draggingLayer.position = [self cellPositionForLocation:[self.delegate locationForPiece:piece]];
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
