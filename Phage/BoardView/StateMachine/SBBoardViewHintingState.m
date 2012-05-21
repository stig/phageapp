//
// Created by SuperPappi on 21/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBBoardViewHintingState.h"
#import "SBPieceLayer.h"
#import "SBBoardView.h"
#import "SBBoardViewUnselectedState.h"
#import "SBCellLayer.h"

@implementation SBBoardViewHintingState

- (void)touchesEnded:(NSSet *)touches {
    CGPoint point = [[touches anyObject] locationInView:self.delegate];
    SBPieceLayer *layer = (SBPieceLayer *)[self.delegate.pieceLayer hitTest:point];

    if (layer) {
        if ([layer isEqual:self.selectedPieceLayer]) {
            SBBoardViewAbstractState *state = [SBBoardViewUnselectedState state];
            state.selectedPieceLayer = layer;
            [self transitionToState:state];

        } else if ([self.delegate.delegate canCurrentPlayerMovePiece:layer.piece]) {
            SBBoardViewAbstractState *state = [[self class] state];
            state.selectedPieceLayer = layer;
            [self transitionToState:state];
        }
    } else {
        SBCellLayer *cell = (SBCellLayer *)[self.delegate.cellLayer hitTest:point];
        if ([self.delegate.delegate canMovePiece:self.selectedPieceLayer.piece toLocation:cell.location]) {
            [self.delegate.delegate movePiece:self.selectedPieceLayer.piece toLocation:cell.location];
        } else {
            // TODO bonk bonk bonk
        }
    }
}


@end