//
// Created by SuperPappi on 20/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBHumanPlayer.h"

@implementation SBHumanPlayer

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
    return YES;
}

@end