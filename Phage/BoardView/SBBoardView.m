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
#import "SBBoardViewDraggedState.h"
#import "SBBoardViewReadonlyState.h"
#import "SBBoardViewUnselectedState.h"
#import "SBBoardViewAbstractState.h"

@implementation SBBoardView {
    NSMutableDictionary *cells;
    NSMutableDictionary *pieces;

    NSUInteger columns;
    NSUInteger rows;
}

@synthesize delegate = _delegate;
@synthesize cellLayer = _cellLayer;
@synthesize pieceLayer = _pieceLayer;
@synthesize draggingLayer = _draggingLayer;
@synthesize draggingLayerCell = _draggingLayerCell;
@synthesize previousDraggingCell = _previousDraggingCell;
@synthesize state = _state;


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        pieces = [[NSMutableDictionary alloc] init];
        cells = [[NSMutableDictionary alloc] init];

        self.cellLayer = [[CALayer alloc] init];
        self.pieceLayer = [[CALayer alloc] init];

        [self.layer addSublayer:self.cellLayer];
        [self.layer addSublayer:self.pieceLayer];

        self.state = [SBBoardViewAbstractState stateWithDelegate:self];
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
            [self.cellLayer addSublayer:layer];
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
            [self.pieceLayer addSublayer:layer];

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

    SBBoardViewAbstractState *newState = [self.delegate isLocalPlayerTurn]
            ? [SBBoardViewUnselectedState state]
            : [SBBoardViewReadonlyState state];

    [self.state transitionToState:newState];
    [self setNeedsDisplay];
}

#pragma mark GridView Touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_state touchesBegan:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [_state touchesMoved:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [_state touchesEnded:touches];
}


@end
