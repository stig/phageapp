//
// Created by SuperPappi on 20/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBBoardViewUnselectedState.h"
#import "SBBoardView.h"
#import "SBBoardViewSelectedState.h"
#import "SBPieceLayer.h"

@implementation SBBoardViewUnselectedState

- (void)touchesBegan:(NSSet *)touches {
    CGPoint point = [[touches anyObject] locationInView:self.delegate];
    SBPieceLayer *layer = (SBPieceLayer *)[self.delegate.pieceLayer hitTest:point];

    if (layer) {
        if ([self.delegate.delegate canCurrentPlayerMovePiece:layer.piece]) {
            self.touchDownPieceLayer = layer;

        } else {
            // TODO: Replace this with a beep and possibly a shiver
            [[[UIAlertView alloc] initWithTitle:@"BEEEP!"
                                        message:@"You can't move that piece; it's not yours!"
                                       delegate:self
                              cancelButtonTitle:@"OK, just testing.."
                              otherButtonTitles:nil] show];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches {
    CGPoint point = [[touches anyObject] locationInView:self.delegate];
    SBPieceLayer *layer = (SBPieceLayer *)[self.delegate.pieceLayer hitTest:point];

    if (layer && [layer isEqual:self.touchDownPieceLayer]) {
        SBBoardViewAbstractState *state = [SBBoardViewSelectedState state];
        state.selectedPieceLayer = layer;
        [self transitionToState:state];
    }
}

@end