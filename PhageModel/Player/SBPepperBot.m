//
// Created by SuperPappi on 08/10/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBPepperBot.h"

@implementation SBPepperBot

+ (id)bot {
    return [self objectWithAlias:NSLocalizedString(@"Sgt Pepper", @"Bot alias")
                     displayName:NSLocalizedString(@"Sergeant Pepper", @"Bot name")];
}

- (id <SBGameTreeSearch>)movePicker {
    SBAlphabetaSearch *ab = [[SBAlphabetaSearch alloc] init];
    ab.maxPly = 1;
    return ab;
}


@end