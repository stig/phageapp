//
// Created by SuperPappi on 20/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBHuman.h"

@implementation SBHuman

+ (id)humanWithAlias:(NSString *)alias {
    return [self objectWithAlias:alias];
}

- (NSString *)description {
    return @"Human";
}

#pragma mark - methods

- (BOOL)isHuman {
    return YES;
}

- (id<SBGameTreeSearch>)movePicker {
    @throw [NSException exceptionWithName:@"unimplemented" reason:@"This belongs on Bot subclasses" userInfo:nil];
}

- (NSString *)displayName {
    return self.alias;
}

@end