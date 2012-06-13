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
#import "SBCellLayer.h"
#import "SBAnimationHelper.h"

@interface SBBoardView () < UIGestureRecognizerDelegate >
@property(strong) CALayer *cellLayer;
@property(strong) CALayer *pieceLayer;
@property(nonatomic, strong) SBPieceLayer *longPressPieceLayer;
@property(nonatomic, strong) NSMutableDictionary *cells;
@property(nonatomic, strong) NSMutableDictionary *pieces;
@property(nonatomic) NSUInteger columns;
@property(nonatomic) NSUInteger rows;


- (void)createBoardCells;
- (void)createInitialBoardPieces;
@end

@implementation SBBoardView

@synthesize delegate = _delegate;
@synthesize cellLayer = _cellLayer;
@synthesize pieceLayer = _pieceLayer;
@synthesize longPressPieceLayer = _longPressPieceLayer;
@synthesize cells = _cells;
@synthesize pieces = _pieces;
@synthesize columns = _columns;
@synthesize rows = _rows;


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.rows = self.columns = 8u;

        self.pieces = [[NSMutableDictionary alloc] init];
        self.cells = [[NSMutableDictionary alloc] init];

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
        longPress.delegate = self;
        [self addGestureRecognizer:longPress];

        [self createBoardCells];
        [self createInitialBoardPieces];
    }
    return self;
}

#pragma mark Cell calculations

- (CGFloat)cellWidth {
    return self.bounds.size.width / self.columns;
}

- (CGFloat)cellHeight {
    return self.bounds.size.height / self.rows;
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
        SBCellLayer *layer = [self.cells objectForKey:loc];
        layer.blocked = [state wasLocationOccupied:loc];
    }];

    for (SBPiece *piece in [state.playerOnePieces arrayByAddingObjectsFromArray:state.playerTwoPieces]) {

        // Animate the piece to its new position
        [CATransaction begin];
        [CATransaction setAnimationDuration:1.0f];

        SBPieceLayer *layer = [self.pieces objectForKey:piece];
        layer.movesLeftLayer.string = [self movesLeftForPiece:piece atState:state];
        layer.position = [self cellPositionForLocation:[state locationForPiece:piece]];

        [CATransaction commit];
    }

    [self setNeedsDisplay];
}

- (void)pickUpPiece:(SBPiece *)piece {
    SBPieceLayer *layer = [self.pieces objectForKey:piece];
    layer.affineTransform = CGAffineTransformMakeScale(2.0, 2.0);
    layer.zPosition++;
    [SBAnimationHelper addPulseAnimationToLayer:layer];
}

- (void)putDownPiece:(SBPiece *)piece {
    SBPieceLayer *layer = [self.pieces objectForKey:piece];
    layer.affineTransform = CGAffineTransformMakeScale(1.0, 1.0);
    layer.zPosition--;
    [SBAnimationHelper removePulseAnimationFromLayer:layer];
}

- (void)movePiece:(SBPiece *)piece toLocation:(SBLocation *)location {
    SBPieceLayer *pieceLayer = [self.pieces objectForKey:piece];
    SBCellLayer *cellLayer = [self.cells objectForKey:location];
    pieceLayer.position = cellLayer.position;
}

- (void)setCellHighlighted:(BOOL)highlighted atLocation:(SBLocation *)location {
    SBCellLayer *cell = [self.cells objectForKey:location];
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

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)sender {
    if (![sender isKindOfClass:[UILongPressGestureRecognizer class]])
        return YES;

    CGPoint point = [sender locationInView:self];
    SBPieceLayer *layer = (SBPieceLayer*)[self.pieceLayer hitTest:point];
    if (layer) {
        return [self.delegate shouldLongPressStartWithPiece:layer.piece];
    }

    return NO;
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)sender {

    CGPoint point = [sender locationInView:self];
    SBCellLayer *cell = (SBCellLayer *)[self.cellLayer hitTest:point];
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            self.longPressPieceLayer = (SBPieceLayer *)[self.pieceLayer hitTest:point];
            [self.delegate longPressStartedWithPiece:self.longPressPieceLayer.piece atLocation:cell.location];
            break;
        case UIGestureRecognizerStateChanged: {
            self.longPressPieceLayer.position = cell.position;
            break;
        }
        case UIGestureRecognizerStateEnded: {
            self.longPressPieceLayer.position = cell.position;
            [self.delegate longPressEndedAtLocation:cell.location];
            break;
        }
        default:
            @throw [NSString stringWithFormat:@"Unhandled gesture state [%u]!", sender.state];
    }
}

- (void)createBoardCells {
    for (NSUInteger r = 0; r < self.rows; r++) {
        for (NSUInteger c = 0; c < self.columns; c++) {
            SBLocation *location = [SBLocation locationWithColumn:c row:r];
            SBCellLayer *layer = [SBCellLayer layerWithLocation:location];
            layer.bounds = [self cellRect];
            layer.position = [self cellPositionForLocation:location];
            layer.blocked = NO;

            CGRect r = CGRectInset(layer.bounds, 6.0, 6.0);
            CGMutablePathRef path = CGPathCreateMutable();

            CGPathMoveToPoint(path, nil, r.origin.x, r.origin.y);
            CGPathAddLineToPoint(path, nil, r.origin.x + r.size.width, r.origin.y + r.size.width);

            CGPathMoveToPoint(path, nil, r.origin.x, r.origin.y + r.size.width);
            CGPathAddLineToPoint(path, nil, r.origin.x + r.size.height, r.origin.y);

            layer.path = path;
            CGPathRelease(path);

            [self.cellLayer addSublayer:layer];
            [self.cells setObject:layer forKey:location];
        }
    }
}

- (NSString *)movesLeftForPiece:(SBPiece *)piece atState:(SBState *)state {
    return [NSString stringWithFormat:@"%u", [state movesLeftForPiece:piece]];
}

- (void)createInitialBoardPieces {
    // TODO this is a nasty hack. It would be better to set it some other way. But it will suffice...
    SBState *state = [[SBState alloc] init];
    for (SBPiece *piece in [state.playerOnePieces arrayByAddingObjectsFromArray:state.playerTwoPieces]) {

        CATextLayer *movesLeftLayer = [CATextLayer layer];
        movesLeftLayer.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7].CGColor;
        movesLeftLayer.foregroundColor = [UIColor whiteColor].CGColor;
        movesLeftLayer.contentsScale = [[UIScreen mainScreen] scale];
        movesLeftLayer.frame = CGRectMake([self cellWidth] - 14, 0, 14, 14);
        movesLeftLayer.fontSize = 14.0;
        movesLeftLayer.cornerRadius = 7.0;
        movesLeftLayer.alignmentMode = kCAAlignmentCenter;
        movesLeftLayer.string = [self movesLeftForPiece:piece atState:state];

        SBPieceLayer *layer = [SBPieceLayer layerWithPiece:piece];
        layer.bounds = [self cellRect];
        layer.path = [piece pathInRect:layer.bounds];
        layer.movesLeftLayer = movesLeftLayer;
        layer.position = [self cellPositionForLocation:[state locationForPiece:piece]];
        layer.movesLeftLayer = movesLeftLayer;
        [layer addSublayer:movesLeftLayer];

        [self.pieces setObject:layer forKey:piece];
        [self.pieceLayer addSublayer:layer];
    }
}



@end
