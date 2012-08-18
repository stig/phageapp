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

- (id)initWithAlias:(NSString *)alias human:(BOOL)human outcome:(SBPlayerOutcome)outcome {
    self = [super init];
    if (self) {
        _alias = alias;
        _human = human;
        _outcome = outcome;
    }
    return self;
}

+ (id)playerWithAlias:(NSString *)alias human:(BOOL)human outcome:(SBPlayerOutcome)outcome {
    return [[SBPlayer alloc] initWithAlias:alias human:human outcome:outcome];
}

+ (id)playerWithAlias:(NSString *)alias human:(BOOL)human {
    return [self playerWithAlias:alias human:human outcome:SBPlayerOutcomeNone];
}

+ (id)playerWithAlias:(NSString *)alias {
    return [self playerWithAlias:alias human:NO];
}

+ (id)player {
    return [self playerWithAlias:nil];
}

#pragma mark - methods

- (id)playerWithOutcome:(SBPlayerOutcome)outcome {
    return [[self class] playerWithAlias:self.alias human:self.isHuman outcome:outcome];
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInteger:PlayerVersion forKey:PlayerVersionKey];
    [coder encodeObject:self.alias forKey:AliasKey];
    [coder encodeInteger:self.outcome forKey:OutcomeKey];
    [coder encodeBool:self.isHuman forKey:LocalHumanKey];
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

    return [self initWithAlias:[coder decodeObjectForKey:AliasKey]
                         human:[coder decodeBoolForKey:LocalHumanKey]
                       outcome:(SBPlayerOutcome)[coder decodeIntegerForKey:OutcomeKey]];
}



@end