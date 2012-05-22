//
// Created by SuperPappi on 21/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBBoardViewHintingState.h"
#import "SBBoardViewUnselectedState.h"
#import "SBBoardView.h"
#import "SBPieceLayer.h"
#import "SBLocation.h"
#import "SBPiece.h"
#import "SBCellLayer.h"

@implementation SBBoardViewHintingState

- (void)transitionIn {
    [super transitionIn];

    SBPiece *piece = self.selectedPieceLayer.piece;
    for (SBCellLayer *cell in self.delegate.cellLayer.sublayers) {
        cell.highlighted = [self.delegate.delegate canMovePiece:piece toLocation:cell.location];
    }
}

- (void)transitionOut {
    [super transitionOut];
    for (SBCellLayer *cell in self.delegate.cellLayer.sublayers) {
        cell.highlighted = NO;
    }
}

- (void)touchesEnded:(NSSet *)touches {
    [self touchesEnded:touches nextStateClass:[SBBoardViewUnselectedState class]];
}

@end