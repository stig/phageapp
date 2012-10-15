//
// Created by SuperPappi on 13/10/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBCarrotBot.h"
#import "SBOpponentMobilityMinimisingMovePicker.h"
#import "Scrutor.h"

@implementation SBCarrotBot

+ (id)bot {
    return [self botWithAlias:NSLocalizedString(@"Cpt Carrot", @"Bot alias")];
}

- (id<SBGameTreeSearch>)movePicker {
    SBAlphabetaSearch *ab = [[SBAlphabetaSearch alloc] init];
    ab.maxPly = 2;
    return ab;
}

@end