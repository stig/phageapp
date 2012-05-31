//
// Created by SuperPappi on 25/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBBoardViewConfirmingState.h"
#import "SBCellLayer.h"
#import "SBPieceLayer.h"

@interface SBBoardViewConfirmingState () < UIActionSheetDelegate >
@end

static NSString *const kSBPhageConfirmPerformMoveKey = @"SBPhageConfirmPerformMoveKey";

@implementation SBBoardViewConfirmingState

@synthesize droppedCellLayer = _droppedCellLayer;
@synthesize previousState = _previousState;
@synthesize selectedPieceLayerOriginalPosition = _selectedPieceLayerOriginalPosition;


- (void)performConfirmedMove {
    [self.delegate movePiece:self.selectedPieceLayer.piece toLocation:self.droppedCellLayer.location];
}

- (void)transitionIn {
    [super transitionIn];
    self.selectedPieceLayer.position = self.droppedCellLayer.position;
    [self.delegate cellLayerForPoint:self.selectedPieceLayerOriginalPosition].blocked = YES;

    if (![[NSUserDefaults standardUserDefaults] boolForKey:kSBPhageConfirmPerformMoveKey]) {
        UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"Perform this move?"
                                                        delegate:self
                                               cancelButtonTitle:@"No"
                                          destructiveButtonTitle:@"Yes; don't ask again"
                                               otherButtonTitles:@"Yes", nil];
        [as showInView:[self.delegate actionSheetView]];
    } else {
        [self performConfirmedMove];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));
    if (actionSheet.cancelButtonIndex == buttonIndex) {
        self.selectedPieceLayer.position = self.selectedPieceLayerOriginalPosition;
        [self.delegate cellLayerForPoint:self.selectedPieceLayerOriginalPosition].blocked = NO;
        [self.delegate transitionToState:self.previousState];
    } else {
        [self performConfirmedMove];
        if (actionSheet.destructiveButtonIndex ==  buttonIndex) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:YES forKey:kSBPhageConfirmPerformMoveKey];
            [defaults synchronize];
        }
    }
}

@end