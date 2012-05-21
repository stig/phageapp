//
// Created by SuperPappi on 20/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBBoardViewDraggedState.h"
#import "SBBoardView.h"
#import "SBPieceLayer.h"
#import "SBCellLayer.h"
#import "SBBoardViewSelectedState.h"

@implementation SBBoardViewDraggedState
@synthesize previousState = _previousState;


- (void)touchesBegan:(NSSet *)touches {

    CGPoint point = [[touches anyObject] locationInView:self.delegate];
    SBPieceLayer *layer = (SBPieceLayer *)[self.delegate.pieceLayer hitTest:point];
    if (layer) {
        NSLog(@"Found layer: %@", layer.name);

        if (![self.delegate.delegate canCurrentPlayerMovePiece:layer.piece]) {
            [[[UIAlertView alloc] initWithTitle:@"BEEEP!" message:@"You can't move that piece; it's not yours!" delegate:self cancelButtonTitle:@"OK, just testing.." otherButtonTitles:nil] show];
            return;
        }

        self.delegate.draggingLayer = layer;
        self.delegate.draggingLayerCell = (SBCellLayer *)[self.delegate.cellLayer hitTest:point];
        // TODO zoom the layer so it looks like it's picked up
    }

}

- (void)touchesMoved:(NSSet *)touches {
    if (self.delegate.draggingLayer) {
        SBCellLayer *cell = (SBCellLayer*)[self.delegate.cellLayer hitTest:[[touches anyObject] locationInView:self.delegate]];
        if (cell) {
            if (![cell isEqual:self.delegate.previousDraggingCell]) {
                self.delegate.previousDraggingCell.highlighted = NO;
                self.delegate.draggingLayer.position = cell.position;
                cell.highlighted = [self.delegate.delegate canMovePiece:self.delegate.draggingLayer.piece toLocation:cell.location];
            }
            self.delegate.previousDraggingCell = cell;
        }
    }

}

- (void)touchesEnded:(NSSet *)touches {
    if (self.delegate.draggingLayer) {
        SBPiece *piece = self.delegate.draggingLayer.piece;
        SBCellLayer *cell = (SBCellLayer *)[self.delegate.cellLayer hitTest:[[touches anyObject] locationInView:self.delegate]];
        if (cell && [self.delegate.delegate canMovePiece:piece toLocation:cell.location]) {
            NSLog(@"%@ can be moved to %@", piece, cell.location);
            self.delegate.draggingLayer.position = cell.position;
            [self.delegate.delegate movePiece:piece toLocation:cell.location];

        } else {
            NSLog(@"%@ is NOT a valid move location for %@", cell.location, piece);
            self.delegate.draggingLayer.position = self.delegate.draggingLayerCell.position;
        }
        self.delegate.draggingLayer = nil;
        self.delegate.previousDraggingCell.highlighted = NO;
        self.delegate.previousDraggingCell = nil;
    }
}


@end