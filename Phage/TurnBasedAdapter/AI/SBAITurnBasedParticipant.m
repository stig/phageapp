//
//  Created by s.brautaset@london.net-a-porter.com on 27/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBAITurnBasedParticipant.h"


@implementation SBAITurnBasedParticipant
@synthesize matchOutcome = _matchOutcome;
@synthesize playerID = _playerID;

- (id)initWithPlayerID:(NSString *)playerID {
    self = [super init];
    if (self) {
        _playerID = playerID;
    }
    return self;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToTurnBasedParticipant:other];
}

- (BOOL)isEqualToTurnBasedParticipant:(SBAITurnBasedParticipant *)other {
    if (self == other)
        return YES;
    return [_playerID isEqualToString:other.playerID];
}

- (NSUInteger)hash {
    return [_playerID hash];
}


@end