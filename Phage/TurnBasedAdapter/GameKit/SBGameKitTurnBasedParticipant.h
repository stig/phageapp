//
//  Created by stig on 26/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "SBTurnBasedParticipant.h"


@interface SBGameKitTurnBasedParticipant : NSObject < SBTurnBasedParticipant >
@property(readonly) GKTurnBasedParticipant *wrappedParticipant;
- (id)initWithParticipant:(GKTurnBasedParticipant *)participant;
- (BOOL)isEqualToTurnBasedParticipant:(SBGameKitTurnBasedParticipant *)other;
@end