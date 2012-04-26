//
//  Created by stig on 26/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@protocol SBTurnBasedMatch;
@protocol SBTurnBasedParticipant;

@protocol SBTurnBasedMatchHelperDelegate
- (void)enterNewGame:(id<SBTurnBasedMatch>)match;
- (void)takeTurn:(id<SBTurnBasedMatch>)match;
- (void)layoutMatch:(id<SBTurnBasedMatch>)match;
- (id<SBTurnBasedParticipant>)nextParticipantForMatch:(id<SBTurnBasedMatch>)match;
- (void)receiveEndGame:(id<SBTurnBasedMatch>)match;
- (void)sendTitle:(NSString *)title notice:(NSString *)notice forMatch:(id<SBTurnBasedMatch>)match;
@end

@protocol SBTurnBasedMatchHelper
@property(weak) id<SBTurnBasedMatchHelperDelegate> delegate;
@property(strong, readonly) id<SBTurnBasedMatch> currentMatch;
- (void)findMatch;
- (BOOL)isLocalPlayerTurn:(id<SBTurnBasedMatch>)match;
@end