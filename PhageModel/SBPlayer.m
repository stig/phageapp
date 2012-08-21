//
// Created by SuperPappi on 20/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBPlayer.h"

static NSString *VERSION = @"v";
static NSString *ALIAS = @"a";
static NSString *HUMAN = @"h";
static NSString *OUTCOME = @"o";

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

#pragma mark - !NSCoding

- (NSDictionary *)toPropertyList {
    return @{
    @"v":    @1,
        ALIAS:      self.alias,
        HUMAN:      @(self.human),
        OUTCOME:    @(self.outcome)
    };
}

+ (id)playerFromPropertyList:(NSDictionary *)dict {
    if ([dict[@"v"] compare:@1] > 0)
        @throw @"Unsupported version; please upgrade Phage!";

    return [[self class] playerWithAlias:dict[ALIAS]
                                   human:[dict[HUMAN] boolValue]
                                 outcome:(SBPlayerOutcome) [dict[OUTCOME] integerValue]];
}


@end