//
// Created by SuperPappi on 21/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBBoardViewHintingState.h"
#import "SBBoardViewUnselectedState.h"
#import "SBPieceLayer.h"
#import "SBPiece.h"
#import "SBCellLayer.h"
#import "SBBoardViewHintingDraggedState.h"

@implementation SBBoardViewHintingState

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

- (Class)draggedStateClass {
    return [SBBoardViewHintingDraggedState class];
}

- (void)touchesEnded:(NSSet *)touches {
    [self touchesEnded:touches nextStateClass:[SBBoardViewUnselectedState class]];
}

@end