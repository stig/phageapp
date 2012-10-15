//
// Created by SuperPappi on 09/10/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBBot.h"

@implementation SBBot

+ (id)bot {
    @throw [NSException exceptionWithName:@"unimplemented" reason:@"Must be implemented in subclass" userInfo:nil];
}

- (NSString *)description {
    return self.alias;
}

#pragma mark - methods

- (BOOL)isHuman {
    return NO;
}

- (id<SBGameTreeSearch>)movePicker {
    @throw [NSException exceptionWithName:@"unimplemented" reason:@"Must be implemented in subclass" userInfo:nil];
}


@end