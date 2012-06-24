//
// Created by SuperPappi on 20/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBHuman.h"

@implementation SBHuman

@synthesize alias = _alias;
@synthesize outcome = _outcome;


+ (id)playerWithAlias:(NSString *)alias {
    return [[self alloc] initWithAlias:alias];
}

- (id)initWithAlias:(NSString *)alias {
    self = [super init];
    if (self) {
        _alias = alias;
        self.outcome = SBPlayerOutcomeNone;
    }
    return self;
}

- (BOOL)isLocalHuman {
    return YES;
}

@end