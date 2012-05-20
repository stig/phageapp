//
// Created by SuperPappi on 20/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBBoardViewDraggedState.h"
#import "SBBoardView.h"
#import "SBPieceLayer.h"
#import "SBCellLayer.h"

@implementation SBBoardViewDraggedState

- (void)touchesBegan:(NSSet *)touches inBoardView:(SBBoardView *)boardView {

    CGPoint point = [[touches anyObject] locationInView:boardView];
    SBPieceLayer *layer = (SBPieceLayer *)[boardView.pieceLayer hitTest:point];
    if (layer) {
        NSLog(@"Found layer: %@", layer.name);

        if (![boardView.delegate canCurrentPlayerMovePiece:layer.piece]) {
            [[[UIAlertView alloc] initWithTitle:@"BEEEP!" message:@"You can't move that piece; it's not yours!" delegate:self cancelButtonTitle:@"OK, just testing.." otherButtonTitles:nil] show];
            return;
        }

        boardView.draggingLayer = layer;
        boardView.draggingLayerCell = (SBCellLayer *)[boardView.cellLayer hitTest:point];
        // TODO zoom the layer so it looks like it's picked up
    }

}

- (void)touchesMoved:(NSSet *)touches inBoardView:(SBBoardView *)boardView {
    if (boardView.draggingLayer) {
        SBCellLayer *cell = (SBCellLayer*)[boardView.cellLayer hitTest:[[touches anyObject] locationInView:boardView]];
        if (cell) {
            if (![cell isEqual:boardView.previousDraggingCell]) {
                boardView.previousDraggingCell.highlighted = NO;
                boardView.draggingLayer.position = cell.position;
                cell.highlighted = [boardView.delegate canMovePiece:boardView.draggingLayer.piece toLocation:cell.location];
            }
            boardView.previousDraggingCell = cell;
        }
    }

}

- (void)touchesEnded:(NSSet *)touches inBoardView:(SBBoardView *)boardView {
    if (boardView.draggingLayer) {
        SBPiece *piece = boardView.draggingLayer.piece;
        SBCellLayer *cell = (SBCellLayer *)[boardView.cellLayer hitTest:[[touches anyObject] locationInView:boardView]];
        if (cell && [boardView.delegate canMovePiece:piece toLocation:cell.location]) {
            NSLog(@"%@ can be moved to %@", piece, cell.location);
            boardView.draggingLayer.position = cell.position;
            [boardView.delegate movePiece:piece toLocation:cell.location];

        } else {
            NSLog(@"%@ is NOT a valid move location for %@", cell.location, piece);
            boardView.draggingLayer.position = boardView.draggingLayerCell.position;
        }
        boardView.draggingLayer = nil;
        boardView.previousDraggingCell.highlighted = NO;
        boardView.previousDraggingCell = nil;
    }
}


@end