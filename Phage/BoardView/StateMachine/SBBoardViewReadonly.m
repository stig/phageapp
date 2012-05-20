//
// Created by SuperPappi on 20/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBBoardViewReadonly.h"

@implementation SBBoardViewReadonly

- (void)touchesBegan:(NSSet *)touches inBoardView:(SBBoardView *)boardView {
    [[[UIAlertView alloc] initWithTitle:@"Patience!"
                                message:@"Wait for your turn.."
                               delegate:self
                      cancelButtonTitle:@"OK, chill"
                      otherButtonTitles:nil] show];
}

- (void)touchesMoved:(NSSet *)touches inBoardView:(SBBoardView *)boardView {}

- (void)touchesEnded:(NSSet *)touches inBoardView:(SBBoardView *)boardView {}

@end