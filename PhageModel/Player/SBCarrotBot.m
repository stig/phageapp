//
// Created by SuperPappi on 13/10/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBCarrotBot.h"

@implementation SBCarrotBot

+ (id)bot {
    return [self objectWithAlias:NSLocalizedString(@"Cpt Carrot", @"Bot alias")
                     displayName:NSLocalizedString(@"Captain Carrot", @"Bot name")];
}

- (id <SBGameTreeSearch>)movePicker {
    SBAlphabetaSearch *ab = [[SBAlphabetaSearch alloc] init];
    ab.maxPly = 2;
    return ab;
}

@end