//
//  GridView.m
//  Phage
//
//  Created by Stig Brautaset on 04/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBBoardView.h"
#import "SBState.h"
#import "SBLocation.h"
#import "SBPieceLayer.h"
#import "SBMovesLeftLayer.h"
#import "SBCellLayer.h"

@implementation SBBoardView {
    SBCellLayer *draggingLayerCell;
    SBPieceLayer *draggingLayer;
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
        SBCellLayer *layer = [cells objectForKey:loc];
        if (!layer) {
            layer = [SBCellLayer layerWithLocation:loc];
            layer.bounds = [self cellRect];
            layer.position = [self cellPositionForLocation:loc];
            [cells setObject:layer forKey:loc];
            [cellLayer addSublayer:layer];
        }

        layer.blocked = [state wasLocationOccupied:loc];

        [layer setNeedsDisplay];
    }];

    for (SBPiece *piece in [state.playerOnePieces arrayByAddingObjectsFromArray:state.playerTwoPieces]) {

        SBPieceLayer *layer = [pieces objectForKey:piece];
        if (!layer) {
            layer = [SBPieceLayer layerWithPiece:piece];
            layer.bounds = [self cellRect];
            [layer setNeedsDisplay];

            [pieces setObject:layer forKey:piece];
            [pieceLayer addSublayer:layer];

            SBMovesLeftLayer *movesLeftLayer = [SBMovesLeftLayer layer];
            movesLeftLayer.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7].CGColor;
            movesLeftLayer.foregroundColor = [UIColor whiteColor].CGColor;
            movesLeftLayer.contentsScale = [[UIScreen mainScreen] scale];
            movesLeftLayer.frame = CGRectMake(layer.bounds.size.width - 14, 0, 14, 14);
            movesLeftLayer.fontSize = 14.0;
            movesLeftLayer.cornerRadius = 7.0;
            movesLeftLayer.alignmentMode = kCAAlignmentCenter;

            layer.movesLeftLayer = movesLeftLayer;
        }

        layer.movesLeftLayer.movesLeft = [state movesLeftForPiece:piece];

        // Animate the piece to its new position
        [CATransaction begin];
        [CATransaction setAnimationDuration:1.0f];
        layer.position = [self cellPositionForLocation:[state locationForPiece:piece]];
        [CATransaction commit];
    }

    [self setNeedsDisplay];
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
    SBPieceLayer *layer = (SBPieceLayer *)[pieceLayer hitTest:point];
    if (layer) {
        NSLog(@"Found layer: %@", layer.name);

        if (![self.delegate canCurrentPlayerMovePiece:layer.piece]) {
            [[[UIAlertView alloc] initWithTitle:@"BEEEP!" message:@"You can't move that piece; it's not yours!" delegate:self cancelButtonTitle:@"OK, just testing.." otherButtonTitles:nil] show];
            return;
        }

        draggingLayer = layer;
        draggingLayerCell = (SBCellLayer *)[cellLayer hitTest:point];
        // TODO zoom the layer so it looks like it's picked up
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (draggingLayer) {
        CALayer *cell = [cellLayer hitTest:[self pointOfTouch:touches]];
        if (cell)
            draggingLayer.position = cell.position;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (draggingLayer) {
        SBPiece *piece = draggingLayer.piece;
        SBCellLayer *cell = (SBCellLayer *)[cellLayer hitTest:[self pointOfTouch:touches]];
        if (cell && [self.delegate canMovePiece:piece toLocation:cell.location]) {
            NSLog(@"%@ can be moved to %@", piece, cell.location);
            draggingLayer.position = [self cellPositionForLocation:cell.location];
            [self.delegate movePiece:piece toLocation:cell.location];

        } else {
            NSLog(@"%@ is NOT a valid move location for %@", cell.location, piece);
            draggingLayer.position = draggingLayerCell.position;
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
