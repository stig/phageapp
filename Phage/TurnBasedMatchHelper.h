//
//  Created by stig on 13/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

@protocol TurnBasedMatchHelperDelegate
- (void)enterNewGame:(GKTurnBasedMatch *)match;
- (void)takeTurn:(GKTurnBasedMatch *)match;
- (void)layoutMatch:(GKTurnBasedMatch *)match;
- (GKTurnBasedParticipant*)nextParticipantForMatch:(GKTurnBasedMatch*)match;
- (void)receiveEndGame:(GKTurnBasedMatch *)match;
- (void)sendNotice:(NSString *)notice forMatch:(GKTurnBasedMatch *)match;
@end

@interface TurnBasedMatchHelper : NSObject <GKTurnBasedMatchmakerViewControllerDelegate, GKTurnBasedEventHandlerDelegate> {
    @private
    UIViewController *_presentingViewController;
    id<TurnBasedMatchHelperDelegate> _delegate;
}

@property (strong, readonly) GKTurnBasedMatch *currentMatch;

- (id)initWithPresentingViewController:(UIViewController*)vc delegate:(id<TurnBasedMatchHelperDelegate>)delegate;
- (void)findMatchWithMinPlayers:(NSUInteger)minPlayers maxPlayers:(NSUInteger)maxPlayers;
- (BOOL)isCurrentMatch:(GKTurnBasedMatch*)match;
- (BOOL)isLocalPlayerTurn:(GKTurnBasedMatch*)match;

@end