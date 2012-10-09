//
// Created by SuperPappi on 09/10/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBBot.h"

@implementation SBBot

@synthesize alias = _alias;
@synthesize outcome = _outcome;

- (id)initWithAlias:(NSString *)alias outcome:(SBPlayerOutcome)outcome {
    self = [super init];
    if (self) {
        _alias = alias;
        _outcome = outcome;
    }
    return self;
}

+ (id)botWithAlias:(NSString *)alias {
    return [[self alloc] initWithAlias:alias outcome:SBPlayerOutcomeNone];
}

+ (id)bot {
    @throw [NSException exceptionWithName:@"unimplemented" reason:@"Must be implemented in subclass" userInfo:nil];
}

- (BOOL)isEqual:(id)object {
    return [self class] == [object class] && [self.alias isEqualToString:[object alias]];
}

- (NSUInteger)hash {
    return [self.alias hash];
}

- (NSString *)description {
    return [NSStringFromClass(self.class) substringFromIndex:2];
}

#pragma mark - methods

- (id)withOutcome:(SBPlayerOutcome)outcome {
    return [[[self class] alloc] initWithAlias:self.alias outcome:outcome];
}

- (BOOL)isHuman {
    return NO;
}

- (id<SBMovePicker>)movePicker {
    @throw [NSException exceptionWithName:@"unimplemented" reason:@"Must be implemented in subclass" userInfo:nil];
}


@end