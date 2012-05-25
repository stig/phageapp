//
// Created by SuperPappi on 25/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBBoardViewConfirmingState.h"
#import "SBCellLayer.h"
#import "SBBoardView.h"
#import "SBPieceLayer.h"

@interface SBBoardViewConfirmingState () < UIAlertViewDelegate >
@end

@implementation SBBoardViewConfirmingState

@synthesize droppedCellLayer = _droppedCellLayer;
@synthesize previousState = _previousState;
@synthesize selectedPieceLayerOriginalPosition = _selectedPieceLayerOriginalPosition;


- (void)transitionIn {
    [super transitionIn];

    self.selectedPieceLayer.position = self.droppedCellLayer.position;

    [[[UIAlertView alloc] initWithTitle:@"Perform this move?"
                                message:@""
                               delegate:self
                      cancelButtonTitle:@"No"
                      otherButtonTitles:@"Yes", nil] show];
}

- (void)transitionOut {
    [super transitionOut];
    self.selectedPieceLayer.position = self.selectedPieceLayerOriginalPosition;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));
    if (0 == buttonIndex) {
        [self transitionToState:self.previousState];
    } else {
        [self.delegate.delegate movePiece:self.selectedPieceLayer.piece toLocation:self.droppedCellLayer.location];
    }
}

@end