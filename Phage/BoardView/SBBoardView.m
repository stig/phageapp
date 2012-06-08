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
#import "SBAnimationHelper.h"

@interface SBBoardView ()
@property(strong) CALayer *cellLayer;
@property(strong) CALayer *pieceLayer;

- (void)createBoardCells;
- (void)createInitialBoardPieces;
@end

@implementation SBBoardView {
    NSMutableDictionary *cells;
    NSMutableDictionary *pieces;

    NSUInteger columns, rows;
}

@synthesize delegate = _delegate;
@synthesize cellLayer = _cellLayer;
@synthesize pieceLayer = _pieceLayer;


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        rows = columns = 8u;

        pieces = [[NSMutableDictionary alloc] init];
        cells = [[NSMutableDictionary alloc] init];

        self.cellLayer = [[CALayer alloc] init];
        self.pieceLayer = [[CALayer alloc] init];

        [self.layer addSublayer:self.cellLayer];
        [self.layer addSublayer:self.pieceLayer];

        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2u;
        [self addGestureRecognizer:doubleTap];

        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [singleTap requireGestureRecognizerToFail:doubleTap];
        [self addGestureRecognizer:singleTap];

        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                action:@selector(handleLongPress:)];
        [self addGestureRecognizer:longPress];

        [self createBoardCells];
        [self createInitialBoardPieces];
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

    [state enumerateLocationsUsingBlock:^(SBLocation *loc) {
        SBCellLayer *layer = [cells objectForKey:loc];
        layer.blocked = [state wasLocationOccupied:loc];
    }];

    for (SBPiece *piece in [state.playerOnePieces arrayByAddingObjectsFromArray:state.playerTwoPieces]) {

        // Animate the piece to its new position
        [CATransaction begin];
        [CATransaction setAnimationDuration:1.0f];

        SBPieceLayer *layer = [pieces objectForKey:piece];
        layer.movesLeftLayer.movesLeft = [state movesLeftForPiece:piece];
        layer.position = [self cellPositionForLocation:[state locationForPiece:piece]];

        [CATransaction commit];
    }

    [self setNeedsDisplay];
}

- (void)pickUpPiece:(SBPiece *)piece {
    SBPieceLayer *layer = [pieces objectForKey:piece];
    [SBAnimationHelper addPulseAnimationToLayer:layer];
}

- (void)putDownPiece:(SBPiece *)piece {
    SBPieceLayer *layer = [pieces objectForKey:piece];
    [SBAnimationHelper removePulseAnimationFromLayer:layer];
}

- (void)movePiece:(SBPiece *)piece toLocation:(SBLocation *)location {
    SBPieceLayer *pieceLayer = [pieces objectForKey:piece];
    SBCellLayer *cellLayer = [cells objectForKey:location];
    pieceLayer.position = cellLayer.position;
}

- (void)setCellHighlighted:(BOOL)highlighted atLocation:(SBLocation *)location {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));
    SBCellLayer *cell = [cells objectForKey:location];
    cell.highlighted = highlighted;
    [cell setNeedsDisplay];
}


#pragma mark Gesture Handlers

- (void)handleSingleTap:(UITapGestureRecognizer *)sender {
    NSParameterAssert(UIGestureRecognizerStateEnded == sender.state);
    CALayer *layer = [self.layer hitTest:[sender locationInView:self]];
    if ([layer isKindOfClass:[SBPieceLayer class]]) {
        [self.delegate handleSingleTapWithPiece:((SBPieceLayer *)layer).piece];

    } else if ([layer isKindOfClass:[SBCellLayer class]]) {
        [self.delegate handleSingleTapWithLocation:((SBCellLayer *)layer).location];

    } else {
        @throw @"Cannot get here";
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)sender {
    NSParameterAssert(UIGestureRecognizerStateEnded == sender.state);
    CALayer *layer = [self.layer hitTest:[sender locationInView:self]];
    if ([layer isKindOfClass:[SBPieceLayer class]]) {
        [self.delegate handleDoubleTapWithPiece:((SBPieceLayer *)layer).piece];

    } else if ([layer isKindOfClass:[SBCellLayer class]]) {
        [self.delegate handleDoubleTapWithLocation:((SBCellLayer *)layer).location];

    } else {
        @throw @"Cannot get here";
    }
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)sender {
    CALayer *layer = [self.layer hitTest:[sender locationInView:self]];
    if ([layer isKindOfClass:[SBPieceLayer class]]) {
        SBPiece *piece = ((SBPieceLayer *)layer).piece;
        switch (sender.state) {
            case UIGestureRecognizerStateBegan:
                if ([self.delegate shouldLongPressStartWithPiece:piece]) {
                    [self.delegate longPressStartedWithPiece:piece];
                }
                break;
            case UIGestureRecognizerStateChanged:
                break;
            case UIGestureRecognizerStateEnded:
                break;
            default:
                @throw [NSString stringWithFormat:@"Unhandled guesture state [%u] for piece", sender.state];
        }
    } else if ([layer isKindOfClass:[SBCellLayer class]]) {
        SBLocation *location = ((SBCellLayer *)layer).location;
        switch (sender.state) {
            case UIGestureRecognizerStateBegan:
                if ([self.delegate shouldLongPressStartWithLocation:location]) {
                    [self.delegate longPressStartedWithLocation:location];
                }
                break;
            case UIGestureRecognizerStateChanged:
                break;
            case UIGestureRecognizerStateEnded:
                break;
            default:
                @throw [NSString stringWithFormat:@"Unhandled guesture state [%u] for piece", sender.state];
            }
    } else {
        @throw @"Cannot get here";
    }
}

- (void)createBoardCells {
    for (NSUInteger r = 0; r < rows; r++) {
        for (NSUInteger c = 0; c < columns; c++) {
            SBLocation *location = [SBLocation locationWithColumn:c row:r];
            SBCellLayer *layer = [SBCellLayer layerWithLocation:location];
            layer.bounds = [self cellRect];
            layer.position = [self cellPositionForLocation:location];
            layer.blocked = NO;
            [self.cellLayer addSublayer:layer];
            [layer setNeedsDisplay];
            [cells setObject:layer forKey:location];
        }
    }
}

- (void)createInitialBoardPieces {
    // TODO this is a nasty hack. It would be better to set it some other way. But it will suffice...
    SBState *state = [[SBState alloc] init];
    for (SBPiece *piece in [state.playerOnePieces arrayByAddingObjectsFromArray:state.playerTwoPieces]) {

        SBMovesLeftLayer *movesLeftLayer = [SBMovesLeftLayer layer];
        movesLeftLayer.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7].CGColor;
        movesLeftLayer.foregroundColor = [UIColor whiteColor].CGColor;
        movesLeftLayer.contentsScale = [[UIScreen mainScreen] scale];
        movesLeftLayer.frame = CGRectMake([self cellWidth] - 14, 0, 14, 14);
        movesLeftLayer.fontSize = 14.0;
        movesLeftLayer.cornerRadius = 7.0;
        movesLeftLayer.alignmentMode = kCAAlignmentCenter;

        SBPieceLayer *layer = [SBPieceLayer layerWithPiece:piece];
        layer.bounds = [self cellRect];
        layer.movesLeftLayer = movesLeftLayer;
        layer.movesLeftLayer.movesLeft = [state movesLeftForPiece:piece];
        layer.position = [self cellPositionForLocation:[state locationForPiece:piece]];

        [pieces setObject:layer forKey:piece];
        [self.pieceLayer addSublayer:layer];
        [layer setNeedsDisplay];
    }

}


@end
