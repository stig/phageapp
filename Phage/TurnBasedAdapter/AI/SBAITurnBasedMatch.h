//
//  Created by s.brautaset@london.net-a-porter.com on 27/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "SBTurnBasedMatch.h"

@class SBAITurnBasedMatch;
@protocol SBTurnBasedParticipant;

@protocol SBAITurnBasedMatchDelegate
- (void)handleTurnEventForMatch:(SBAITurnBasedMatch *)match;
- (void)handleMatchEnded:(SBAITurnBasedMatch *)match;
@end

@interface SBAITurnBasedMatch : NSObject < SBTurnBasedMatch, NSCoding >

@property(strong) id<SBAITurnBasedMatchDelegate> delegate;
@property(strong) id matchState;
@property(strong) NSArray *participants;
@property(strong) id<SBTurnBasedParticipant> localParticipant;
@property(strong) id<SBTurnBasedParticipant> currentParticipant;
@property(assign) GKTurnBasedMatchStatus status;

@end