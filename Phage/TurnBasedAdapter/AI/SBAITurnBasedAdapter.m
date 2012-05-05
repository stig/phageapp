//
//  Created by s.brautaset@london.net-a-porter.com on 27/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBAITurnBasedAdapter.h"
#import "SBAITurnBasedMatch.h"
#import "SBState.h"
#import "SBAITurnBasedParticipant.h"

@interface SBAITurnBasedAdapter ()
@property(strong) SBAITurnBasedMatch *currentMatch;
@end

@implementation SBAITurnBasedAdapter

@synthesize delegate = _delegate;
@synthesize currentMatch = _currentMatch;


- (void)findMatch {
    NSLog(@"-[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    SBAITurnBasedParticipant *player1 = [[SBAITurnBasedParticipant alloc] init];
    SBAITurnBasedParticipant *player2 = [[SBAITurnBasedParticipant alloc] init];

    SBAITurnBasedMatch *match = [[SBAITurnBasedMatch alloc] init];
    match.participants = [[NSArray alloc] initWithObjects:player1, player2, nil];
    match.matchState = [[SBState alloc] init];
    match.delegate = self;

    self.currentMatch = match;

    [self.delegate handleDidFindMatch:match];
}

// TODO: fix this. Currently local player is always index 0
- (BOOL)isLocalPlayerTurn:(id <SBTurnBasedMatch>)match {
    return ![match.participants indexOfObject:match.currentParticipant];
}


@end