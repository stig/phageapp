//
// Created by SuperPappi on 22/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBBoardViewHintingDraggedState.h"
#import "SBCellLayer.h"
#import "SBPieceLayer.h"

@implementation SBBoardViewHintingDraggedState

- (void)transitionIn {
    [super transitionIn];
    SBPiece *piece = self.selectedPieceLayer.piece;
    for (SBCellLayer *cell in [self.delegate allCellLayers]) {
        cell.highlighted = [self.delegate canMovePiece:piece toLocation:cell.location];
    }
}


- (void)transitionOut {
    [super transitionOut];
    for (SBCellLayer *cell in [self.delegate allCellLayers]) {
        cell.highlighted = NO;
    }
}

- (void)touchesMoved:(NSSet *)touches {
    [self touchesMoved:touches block:NULL];
}



@end