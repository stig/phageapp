//
// Created by SuperPappi on 25/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBBot.h"

@implementation SBBot
@synthesize outcome = _outcome;
@synthesize alias = _alias;

+ (id)playerWithAlias:(NSString *)alias {
    return [[self alloc] initWithAlias:alias];
}

- (id)initWithAlias:(NSString *)alias {
    self = [super init];
    if (self) {
        _alias = alias;
    }
    return self;
}

- (BOOL)isLocalHuman {
    return NO;
}


@end