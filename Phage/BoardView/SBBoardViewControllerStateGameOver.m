//
// Created by SuperPappi on 08/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBBoardViewControllerStateGameOver.h"

@implementation SBBoardViewControllerStateGameOver

- (void)displayMessage {
    [[[UIAlertView alloc] initWithTitle:@"Game Over"
                                message:@"I'm afraid it's too late to make any moves now."
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

@end