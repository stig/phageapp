//
// Created by SuperPappi on 20/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBBoardViewSelectedDraggedState.h"
#import "SBBoardView.h"
#import "SBPieceLayer.h"
#import "SBCellLayer.h"
#import "SBAnimationHelper.h"
#import "SBBoardViewConfirmingState.h"

@implementation SBBoardViewSelectedDraggedState
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
    self.previousCellLayer.highlighted = NO;
}

- (void)touchesMoved:(NSSet*)touches block:(void(^)(SBCellLayer *cell))block {
    SBCellLayer *cellLayer = (SBCellLayer*)[self.delegate.cellLayer hitTest:[[touches anyObject] locationInView:self.delegate]];
    if (cellLayer && ![cellLayer isEqual:self.previousCellLayer]) {
        if (block) block(cellLayer);
        self.selectedPieceLayer.position = cellLayer.position;
        self.previousCellLayer = cellLayer;
    }
}

- (void)touchesMoved:(NSSet *)touches {
    [self touchesMoved:touches block:^(SBCellLayer *cell) {
        cell.highlighted = [self.delegate.delegate canMovePiece:self.selectedPieceLayer.piece toLocation:cell.location];
        self.previousCellLayer.highlighted = NO;
    }];
}

- (void)touchesEnded:(NSSet *)touches {
    SBCellLayer *cellLayer = (SBCellLayer*)[self.delegate.cellLayer hitTest:[[touches anyObject] locationInView:self.delegate]];
    if (cellLayer && [self.delegate.delegate canMovePiece:self.selectedPieceLayer.piece toLocation:cellLayer.location]) {
        SBBoardViewConfirmingState *state = [SBBoardViewConfirmingState state];
        state.droppedCellLayer = cellLayer;
        state.selectedPieceLayer = self.selectedPieceLayer;
        state.selectedPieceLayerOriginalPosition = self.selectedPieceLayerOriginalPosition;
        state.previousState = self.previousState;
        [self transitionToState:state];
    } else {
        NSLog(@"%@ is NOT a valid move location for %@", cellLayer.location, self.selectedPieceLayer.piece);
        self.selectedPieceLayer.position = self.selectedPieceLayerOriginalPosition;
        [self transitionToState:self.previousState];
    }
}


@end