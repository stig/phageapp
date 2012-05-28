//
// Created by SuperPappi on 20/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBBoardViewReadonlyState.h"

@implementation SBBoardViewReadonlyState
@synthesize delegate = _delegate;


- (void)transitionIn {}

- (void)transitionOut {}

- (void)touchesBegan:(NSSet *)touches {
    [[[UIAlertView alloc] initWithTitle:@"Patience!"
                                message:@"Wait for your turn.."
                               delegate:self
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

- (void)touchesMoved:(NSSet *)touches {}

- (void)touchesEnded:(NSSet *)touches {}

@end