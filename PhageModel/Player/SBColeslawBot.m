//
// Created by SuperPappi on 13/10/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBColeslawBot.h"
#import "SBOpponentMobilityMinimisingMovePicker.h"
#import "Scrutor.h"

@implementation SBColeslawBot

+ (id)bot {
    return [self botWithAlias:NSLocalizedString(@"Cpt Coleslaw", @"Bot alias")];
}

- (id<SBMovePicker>)movePicker {
    SBAlphabetaSearch *ab = [[SBAlphabetaSearch alloc] init];
    ab.maxPly = 2;
    return ab;
}

@end