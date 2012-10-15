//
// Created by SuperPappi on 09/10/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBPartsBot.h"

@implementation SBPartsBot

+ (id)bot {
    return [self botWithAlias:NSLocalizedString(@"Pte Parts", @"Bot alias")];
}

- (id<SBGameTreeSearch>)movePicker {
    return [[SBRandomSearch alloc] init];
}


@end