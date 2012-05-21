//
// Created by SuperPappi on 20/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBBoardViewReadonlyState.h"

@implementation SBBoardViewReadonlyState

- (void)touchesBegan:(NSSet *)touches {
    [[[UIAlertView alloc] initWithTitle:@"Patience!"
                                message:@"Wait for your turn.."
                               delegate:self
                      cancelButtonTitle:@"OK, chill"
                      otherButtonTitles:nil] show];
}

- (void)touchesMoved:(NSSet *)touches {}

@end