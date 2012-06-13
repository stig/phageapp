//
// Created by SuperPappi on 07/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBBoardViewControllerStateReadonly.h"

@implementation SBBoardViewControllerStateReadonly


- (void)displayMessage {
    [[[UIAlertView alloc] initWithTitle:@"Opponent Turn"
                                message:@"Please wait for your opponent to make a move."
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (void)handleSingleTapWithPiece:(SBPiece *)piece {
    [super handleSingleTapWithPiece:piece];
    [self displayMessage];
}

- (void)handleSingleTapWithLocation:(SBLocation *)location {
    [super handleSingleTapWithLocation:location];
    [self displayMessage];
}

- (void)handleDoubleTapWithPiece:(SBPiece *)piece {
    [super handleDoubleTapWithPiece:piece];
    [self displayMessage];
}

- (void)handleDoubleTapWithLocation:(SBLocation *)location {
    [super handleDoubleTapWithLocation:location];
    [self displayMessage];
}

@end