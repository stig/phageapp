//
// Created by SuperPappi on 15/10/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBAbstractPlayer.h"

@implementation SBAbstractPlayer

- (id)initWithAlias:(NSString *)alias displayName:(NSString *)displayName outcome:(SBPlayerOutcome)outcome {
    self = [super init];
    if (self) {
        _alias = alias;
        _displayName = displayName;
        _outcome = outcome;
    }
    return self;
}

+ (id)objectWithAlias:(NSString *)alias {
    return [self objectWithAlias:alias displayName:alias];
}

+ (id)objectWithAlias:(NSString *)alias displayName:(NSString *)displayName {
    return [self objectWithAlias:alias displayName:displayName outcome:SBPlayerOutcomeNone];
}

+ (id)objectWithAlias:(NSString *)alias displayName:(NSString *)displayName outcome:(SBPlayerOutcome)outcome {
    return [[[self class] alloc] initWithAlias:alias displayName:displayName outcome:outcome];
}

- (BOOL)isEqual:(id)object {
    return [self class] == [object class] && [self.alias isEqualToString:[object alias]];
}

- (NSUInteger)hash {
    return [self.alias hash];
}

- (id)withOutcome:(SBPlayerOutcome)outcome {
    return [[self class] objectWithAlias:self.alias displayName:self.displayName outcome:outcome];
}

@end