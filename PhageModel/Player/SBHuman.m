//
// Created by SuperPappi on 20/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBHuman.h"

@implementation SBHuman

@synthesize outcome = _outcome;
@synthesize alias = _alias;

- (id)initWithAlias:(NSString *)alias outcome:(SBPlayerOutcome)outcome {
    self = [super init];
    if (self) {
        _alias = alias;
        _outcome = outcome;
    }
    return self;
}

+ (id)humanWithAlias:(NSString *)alias {
    return [[self alloc] initWithAlias:alias outcome:SBPlayerOutcomeNone];
}

#pragma mark - methods

- (id)withOutcome:(SBPlayerOutcome)outcome {
    return [[[self class] alloc] initWithAlias:self.alias outcome:outcome];
}

- (BOOL)isHuman {
    return YES;
}

- (id<SBMovePicker>)movePicker {
    @throw [NSException exceptionWithName:@"unimplemented" reason:@"This belongs on Bot subclasses" userInfo:nil];
}

@end