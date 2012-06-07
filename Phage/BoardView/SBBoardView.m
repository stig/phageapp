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
#import "SBBoardViewSelectedDraggedState.h"

@implementation SBBoardView {
    NSMutableDictionary *cells;
    NSMutableDictionary *pieces;

    NSUInteger columns, rows;
}

@synthesize delegate = _delegate;
@synthesize cellLayer = _cellLayer;
@synthesize pieceLayer = _pieceLayer;
@synthesize state = _state;


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

        self.state = [SBBoardViewAbstractState stateWithDelegate:self];


        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTap.numberOfTapsRequired = 2u;
        [self addGestureRecognizer:doubleTap];

        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [singleTap requireGestureRecognizerToFail:doubleTap];
        [self addGestureRecognizer:singleTap];

        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                action:@selector(handleLongPress:)];
        [self addGestureRecognizer:longPress];


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

- (void)layoutForState:(SBState *)state state:(id <SBBoardViewState>)boardViewState {

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

    [self transitionToState:boardViewState];
    [self setNeedsDisplay];
}

#pragma mark SBBoardViewState

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.state touchesBegan:touches];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.state touchesMoved:touches];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.state touchesEnded:touches];
}

#pragma mark SBBoardViewStateDelegate

- (void)transitionToState:(id<SBBoardViewState>)state {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));
    [self.state transitionOut];

    state.delegate = self;
    [state transitionIn];

    self.state = state;
}

- (CGPoint)pointForTouches:(NSSet *)touches {
    return [[touches anyObject] locationInView:self];
}

- (BOOL)canCurrentPlayerMovePiece:(SBPiece *)piece {
    return [self.delegate canCurrentPlayerMovePiece:piece];
}

- (SBPieceLayer *)pieceLayerForPoint:(CGPoint)point {
    return (SBPieceLayer*)[self.pieceLayer hitTest:point];
}

- (SBCellLayer *)cellLayerForPoint:(CGPoint)point {
    return (SBCellLayer *)[self.cellLayer hitTest:point];
}

- (BOOL)canMovePiece:(SBPiece *)piece toLocation:(SBLocation *)location {
    return [self.delegate canMovePiece:piece toLocation:location];
}

- (NSArray *)allCellLayers {
    return self.cellLayer.sublayers;
}

- (void)movePiece:(SBPiece *)piece toLocation:(SBLocation *)location {
    [self.delegate movePiece:piece toLocation:location];
}

- (UIView *)actionSheetView {
    return self;
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


@end
