//
// Created by SuperPappi on 08/10/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBPepperBot.h"
#import "SBOpponentMobilityMinimisingMovePicker.h"

@implementation SBPepperBot

+ (id)bot {
    return [self botWithAlias:NSLocalizedString(@"Sgt Pepper", @"Bot alias")];
}

- (id<SBGameTreeSearch>)movePicker {
    return [[SBOpponentMobilityMinimisingMovePicker alloc] init];
}


@end