//
// Created by SuperPappi on 09/10/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBPartsBot.h"

@implementation SBPartsBot

+ (id)bot {
    return [self objectWithAlias:NSLocalizedString(@"Pte Parts", @"Bot alias")
                     displayName:NSLocalizedString(@"Private \"Spare\" Parts", @"Bot name")];
}

- (id <SBGameTreeSearch>)movePicker {
    return [[SBRandomSearch alloc] init];
}


@end