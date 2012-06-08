//
// Created by SuperPappi on 08/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBBoardViewControllerHintState.h"

@implementation SBBoardViewControllerHintState

- (void)transitionIn {
    [super transitionIn];
    [self.delegate setLegalDestinationsForPiece:self.selected highlighted:YES];
}

- (void)transitionOut {
    [super transitionOut];
    [self.delegate setLegalDestinationsForPiece:self.selected highlighted:NO];
}


@end