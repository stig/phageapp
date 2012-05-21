//
// Created by SuperPappi on 21/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBBoardViewHintingState.h"
#import "SBBoardViewUnselectedState.h"

@implementation SBBoardViewHintingState

- (void)touchesEnded:(NSSet *)touches {
    [self touchesEnded:touches nextStateClass:[SBBoardViewUnselectedState class]];
}

@end