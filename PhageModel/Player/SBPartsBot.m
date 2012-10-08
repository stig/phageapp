//
// Created by SuperPappi on 09/10/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBPartsBot.h"
#import "SBRandomMovePicker.h"

@implementation SBPartsBot

+ (id)bot {
    return [self botWithAlias:NSLocalizedString(@"Pte Parts", @"Bot alias")];
}

- (id<SBMovePicker>)movePicker {
    return [[SBRandomMovePicker alloc] init];
}


@end