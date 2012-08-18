//
// Created by SuperPappi on 20/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBPlayer.h"

static NSInteger PlayerVersion = 1;
static NSString *PlayerVersionKey = @"v";
static NSString *AliasKey = @"a";
static NSString *OutcomeKey = @"o";
static NSString *LocalHumanKey = @"lh";

@implementation SBPlayer

@synthesize alias = _alias;
@synthesize outcome = _outcome;
@synthesize localHuman = _localHuman;

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInteger:PlayerVersion forKey:PlayerVersionKey];
    [coder encodeObject:self.alias forKey:AliasKey];
    [coder encodeInteger:self.outcome forKey:OutcomeKey];
    [coder encodeBool:self.isLocalHuman forKey:LocalHumanKey];
}

- (id)initWithCoder:(NSCoder *)coder {
    if (![coder containsValueForKey:PlayerVersionKey]) {
        NSLog(@"Unsupported version: null");
        return nil;
    }

    if ([coder decodeIntegerForKey:PlayerVersionKey] > PlayerVersion) {
        NSLog(@"Unsupported version; please upgrade Phage!");
        return nil;
    }

    SBPlayer *player = [SBPlayer playerWithAlias:[coder decodeObjectForKey:AliasKey]];
    player.outcome = [coder decodeIntegerForKey:OutcomeKey];
    player.localHuman = [coder decodeBoolForKey:LocalHumanKey];
    return player;
}


+ (id)playerWithAlias:(NSString *)alias {
    return [[self alloc] initWithAlias:alias];
}

- (id)initWithAlias:(NSString *)alias {
    self = [self init];
    if (!self) return nil;

    self.alias = alias;
    return self;
}

+ (id)player {
    return [[self alloc] init];
}

- (id)init {
    self = [super init];
    if (!self) return nil;

    self.outcome = SBPlayerOutcomeNone;
    return self;
}

@end