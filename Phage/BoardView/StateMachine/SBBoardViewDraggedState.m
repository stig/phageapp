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
@synthesize previousCellLayer = _previousCellLayer;
@synthesize selectedPieceLayerOriginalPosition = _selectedPieceLayerOriginalPosition;


- (void)transitionIn {
    [super transitionIn];
    self.selectedPieceLayerOriginalPosition = self.selectedPieceLayer.position;
    [SBAnimationHelper addPulseAnimationToLayer:self.selectedPieceLayer];
}

- (void)transitionOut {
    [super transitionOut];
    [SBAnimationHelper removePulseAnimationFromLayer:self.selectedPieceLayer];
}


- (void)touchesMoved:(NSSet *)touches {
    SBCellLayer *cellLayer = (SBCellLayer*)[self.delegate.cellLayer hitTest:[[touches anyObject] locationInView:self.delegate]];
    if (cellLayer) {
        if (![cellLayer isEqual:self.previousCellLayer]) {
            cellLayer.highlighted = [self.delegate.delegate canMovePiece:self.selectedPieceLayer.piece toLocation:cellLayer.location];
            self.selectedPieceLayer.position = cellLayer.position;
            self.previousCellLayer.highlighted = NO;
            self.previousCellLayer = cellLayer;
        }
    }
}

- (void)touchesEnded:(NSSet *)touches {
    SBCellLayer *cellLayer = (SBCellLayer*)[self.delegate.cellLayer hitTest:[[touches anyObject] locationInView:self.delegate]];
    if (cellLayer && [self.delegate.delegate canMovePiece:self.selectedPieceLayer.piece toLocation:cellLayer.location]) {
        self.selectedPieceLayer.position = cellLayer.position;
        self.previousCellLayer.highlighted = NO;
        [self.delegate.delegate movePiece:self.selectedPieceLayer.piece toLocation:cellLayer.location];
    } else {
        NSLog(@"%@ is NOT a valid move location for %@", cellLayer.location, self.selectedPieceLayer.piece);
        self.previousCellLayer.highlighted = NO;
        self.selectedPieceLayer.position = self.selectedPieceLayerOriginalPosition;
        [self transitionToState:self.previousState];
    }
}


@end