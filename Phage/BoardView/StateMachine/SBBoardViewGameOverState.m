//
// Created by SuperPappi on 31/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBBoardViewGameOverState.h"

@implementation SBBoardViewGameOverState

- (void)touchesBegan:(NSSet *)touches {
    [[[UIAlertView alloc] initWithTitle:@"This match is finished"
                                message:@"I'm afraid it's too late to make any moves now."
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];

}

@end