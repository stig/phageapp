//
//  Created by stig on 26/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBGameKitTurnBasedParticipant.h"


@implementation SBGameKitTurnBasedParticipant
@synthesize wrappedParticipant = _wrappedParticipant;

- (id)initWithParticipant:(GKTurnBasedParticipant *)participant {
    self = [super init];
    if (self) {
        _wrappedParticipant = participant;
    }
    return self;
}

- (GKTurnBasedMatchOutcome)matchOutcome {
    return _wrappedParticipant.matchOutcome;
}

- (void)setMatchOutcome:(GKTurnBasedMatchOutcome)aMatchOutcome {
    _wrappedParticipant.matchOutcome = aMatchOutcome;
}

#pragma mark Equality

- (BOOL)isEqualToTurnBasedParticipant:(SBGameKitTurnBasedParticipant *)other {
    if (self == other)
        return YES;
    return [_wrappedParticipant isEqual:other.wrappedParticipant];
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToTurnBasedParticipant:other];
}

@end