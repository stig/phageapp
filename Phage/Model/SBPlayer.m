//
// Created by SuperPappi on 20/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBPlayer.h"

@implementation SBPlayer

@synthesize alias = _alias;
@synthesize outcome = _outcome;
@synthesize localHuman = _localHuman;
@synthesize eloScore = _eloScore;
@synthesize matchCount = _matchCount;


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

@end