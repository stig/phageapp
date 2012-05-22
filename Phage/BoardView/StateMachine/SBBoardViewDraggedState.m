//
// Created by SuperPappi on 20/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBBoardViewDraggedState.h"
#import "SBBoardView.h"
#import "SBPieceLayer.h"
#import "SBCellLayer.h"
#import "SBAnimationHelper.h"

@implementation SBBoardViewDraggedState
@synthesize previousState = _previousState;
@synthesize draggingPieceLayer = _draggingPieceLayer;
@synthesize previousCellLayer = _previousCellLayer;
@synthesize draggingPieceLayerOriginalPosition = _draggingPieceLayerOriginalPosition;


- (void)transitionIn {
    [super transitionIn];
    self.draggingPieceLayerOriginalPosition = self.draggingPieceLayer.position;
    [SBAnimationHelper addPulseAnimationToLayer:self.draggingPieceLayer];
}

- (void)transitionOut {
    [super transitionOut];
    [SBAnimationHelper removePulseAnimationFromLayer:self.draggingPieceLayer];
}


- (void)touchesMoved:(NSSet *)touches {
    SBCellLayer *cellLayer = (SBCellLayer*)[self.delegate.cellLayer hitTest:[[touches anyObject] locationInView:self.delegate]];
    if (cellLayer) {
        if (![cellLayer isEqual:self.previousCellLayer]) {
            cellLayer.highlighted = [self.delegate.delegate canMovePiece:self.draggingPieceLayer.piece toLocation:cellLayer.location];
            self.draggingPieceLayer.position = cellLayer.position;
            self.previousCellLayer.highlighted = NO;
            self.previousCellLayer = cellLayer;
        }
    }
}

- (void)touchesEnded:(NSSet *)touches {
    SBCellLayer *cellLayer = (SBCellLayer*)[self.delegate.cellLayer hitTest:[[touches anyObject] locationInView:self.delegate]];
    if (cellLayer && [self.delegate.delegate canMovePiece:self.draggingPieceLayer.piece toLocation:cellLayer.location]) {
        self.draggingPieceLayer.position = cellLayer.position;
        self.previousCellLayer.highlighted = NO;
        [self.delegate.delegate movePiece:self.draggingPieceLayer.piece toLocation:cellLayer.location];
    } else {
        NSLog(@"%@ is NOT a valid move location for %@", cellLayer.location, self.draggingPieceLayer.piece);
        self.previousCellLayer.highlighted = NO;
        self.draggingPieceLayer.position = self.draggingPieceLayerOriginalPosition;
        [self transitionToState:self.previousState];
    }
}


@end