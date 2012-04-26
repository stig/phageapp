//
//  Created by stig on 13/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

@protocol SBGameKitTurnBasedMatchHelperInternalDelegate
- (void)enterNewGame:(GKTurnBasedMatch *)match;
- (void)takeTurn:(GKTurnBasedMatch *)match;
- (void)layoutMatch:(GKTurnBasedMatch *)match;
- (GKTurnBasedParticipant*)nextParticipantForMatch:(GKTurnBasedMatch*)match;
- (void)receiveEndGame:(GKTurnBasedMatch *)match;
- (void)sendTitle:(NSString*)title notice:(NSString *)notice forMatch:(GKTurnBasedMatch *)match;
@end

@interface SBGameKitTurnBasedMatchHelperInternal : NSObject <GKTurnBasedMatchmakerViewControllerDelegate, GKTurnBasedEventHandlerDelegate>
@property(strong) UIViewController *presentingViewController;
@property(strong) id<SBGameKitTurnBasedMatchHelperInternalDelegate> delegate;
@property (strong, readonly) GKTurnBasedMatch *currentMatch;
- (void)findMatch;
- (BOOL)isLocalPlayerTurn:(GKTurnBasedMatch*)match;
@end