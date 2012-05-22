//
// Created by SuperPappi on 20/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBBoardViewSelectedState.h"
#import "SBPieceLayer.h"
#import "SBBoardView.h"
#import "SBBoardViewHintingState.h"
#import "SBCellLayer.h"
#import "SBAnimationHelper.h"

@implementation SBBoardViewSelectedState

- (void)transitionIn {
    [super transitionIn];
    [SBAnimationHelper addPulseAnimationToLayer:self.selectedPieceLayer];
}

- (void)transitionOut {
    [super transitionOut];
    [SBAnimationHelper removePulseAnimationFromLayer:self.selectedPieceLayer];
}


- (void)touchesBegan:(NSSet *)touches {
    CGPoint point = [[touches anyObject] locationInView:self.delegate];
    SBPieceLayer *layer = (SBPieceLayer *)[self.delegate.pieceLayer hitTest:point];

    if (layer) {
        if ([self.delegate.delegate canCurrentPlayerMovePiece:layer.piece]) {
            self.touchDownPieceLayer = layer;
        }
    }
}

- (void)touchesEnded:(NSSet *)touches nextStateClass:(Class)clazz {
    CGPoint point = [[touches anyObject] locationInView:self.delegate];
    SBPieceLayer *layer = (SBPieceLayer *)[self.delegate.pieceLayer hitTest:point];

    if (layer) {
        if ([layer isEqual:self.selectedPieceLayer]) {
            SBBoardViewAbstractState *state = [clazz state];
            state.selectedPieceLayer = layer;
            [self transitionToState:state];

        } else if ([layer isEqual:self.touchDownPieceLayer]) {
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

- (void)touchesEnded:(NSSet *)touches {
    [self touchesEnded:touches nextStateClass:[SBBoardViewHintingState class]];
}

@end