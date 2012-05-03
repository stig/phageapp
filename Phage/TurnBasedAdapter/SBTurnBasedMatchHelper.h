//
//  Created by stig on 26/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "SBTurnBasedMatch.h"

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

@protocol SBTurnBasedMatchHelperAdapter
- (void)findMatch;
- (BOOL)isLocalPlayerTurn:(id <SBTurnBasedMatch>)match;
@end

@interface SBTurnBasedMatchHelper : NSObject <SBTurnBasedMatchHelperAdapter>
@property(weak) id <SBTurnBasedMatchHelperDelegate> delegate;
@property(strong) id<SBTurnBasedMatchHelperAdapter> adapter;
@property(strong, readonly) id<SBTurnBasedMatch> currentMatch;

// Methods for use by the underlying adapters6
- (void)handleDidFindMatch:(id <SBTurnBasedMatch>)match;
- (void)handlePlayerQuitForMatch:(id <SBTurnBasedMatch>)match;
- (void)handleTurnEventForMatch:(id <SBTurnBasedMatch>)match;
- (void)handleMatchEnded:(id <SBTurnBasedMatch>)match;

@end