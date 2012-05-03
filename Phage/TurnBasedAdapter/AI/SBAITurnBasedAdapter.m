//
//  Created by s.brautaset@london.net-a-porter.com on 27/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBAITurnBasedAdapter.h"
#import "SBAITurnBasedMatch.h"
#import "SBState.h"
#import "SBAITurnBasedParticipant.h"

@implementation SBAITurnBasedAdapter

@synthesize delegate = _delegate;

- (void)findMatch {
    NSLog(@"%@", NSStringFromSelector(_cmd));

    SBAITurnBasedParticipant *player1 = [[SBAITurnBasedParticipant alloc] init];
    SBAITurnBasedParticipant *player2 = [[SBAITurnBasedParticipant alloc] init];
    NSArray *participants = [[NSArray alloc] initWithObjects:player1, player2, nil];
    SBState *state = [[SBState alloc] init];

    SBAITurnBasedMatch *match = [[SBAITurnBasedMatch alloc] initWithMatchState:state participants:participants];

    [self.delegate handleDidFindMatch:match];
}

// TODO: fix this. Currently local player is always index 0
- (BOOL)isLocalPlayerTurn:(id <SBTurnBasedMatch>)match {
    return ![match.participants indexOfObject:match.currentParticipant];

}


@end