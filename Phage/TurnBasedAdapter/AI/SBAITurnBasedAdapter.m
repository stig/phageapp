//
//  Created by s.brautaset@london.net-a-porter.com on 27/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBTurnBasedMatch.h"
#import "SBAITurnBasedAdapter.h"
#import "SBState.h"
#import "SBAITurnBasedParticipant.h"
#import "SBMovePicker.h"
#import "SBMove.h"

@interface SBAITurnBasedAdapter ()
@property(strong) SBAITurnBasedMatch *currentMatch;
@end

@implementation SBAITurnBasedAdapter

@synthesize delegate = _delegate;
@synthesize currentMatch = _currentMatch;
@synthesize movePicker = _movePicker;


- (id)init {
    self = [super init];
    if (self) {
        self.movePicker = [[SBMovePicker alloc] init];
    }
    return self;
}


- (void)findMatch {
    NSLog(@"-[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    SBAITurnBasedParticipant *player1 = [[SBAITurnBasedParticipant alloc] initWithPlayerID:@"human"];
    SBAITurnBasedParticipant *player2 = [[SBAITurnBasedParticipant alloc] initWithPlayerID:@"ai"];

    SBAITurnBasedMatch *match = [[SBAITurnBasedMatch alloc] init];
    match.participants = [[NSArray alloc] initWithObjects:player1, player2, nil];
    match.matchState = [[SBState alloc] init];
    match.delegate = self;

    self.currentMatch = match;

    [self.delegate handleDidFindMatch:match];
}

// TODO: fix this. Currently local player is always index 0
- (BOOL)isLocalPlayerTurn:(id <SBTurnBasedMatch>)match {
    NSArray *participants = match.participants;
    id currentParticipant = match.currentParticipant;
    return ![participants indexOfObject:currentParticipant];
}

- (void)matchEnded:(id<SBTurnBasedMatch>)match {
    NSLog(@"-[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    id<SBTurnBasedParticipant> opponent = [self nextParticipantForMatch:match];
    SBState *state = match.matchState;
    if ([state isDraw]) {
        opponent.matchOutcome = GKTurnBasedMatchOutcomeTied;
        match.currentParticipant.matchOutcome = GKTurnBasedMatchOutcomeTied;

    } else if ([state isLoss]) {
        opponent.matchOutcome = GKTurnBasedMatchOutcomeWon;
        match.currentParticipant.matchOutcome = GKTurnBasedMatchOutcomeLost;

    } else {
        opponent.matchOutcome = GKTurnBasedMatchOutcomeLost;
        match.currentParticipant.matchOutcome = GKTurnBasedMatchOutcomeWon;

    }

    [match endMatchInTurnWithMatchState:state completionHandler:^(NSError *error){
        if (error) {
            NSLog(@"Error: %@", error);
        }
    }];
}

- (void)performComputerMoveActionForMatch:(SBAITurnBasedMatch*)match
{
    NSLog(@"%s", sel_getName(_cmd));

    if ([match.matchState isGameOver]) {
        [self matchEnded:match];

    } else if (![self isLocalPlayerTurn:match]) {
        id move = [self.movePicker moveForState:match.matchState];
        NSAssert(move != nil, @"Should not be nil!");

        id successor = [match.matchState successorWithMove:move];
        [match endTurnWithNextParticipant:[self nextParticipantForMatch:match]
                               matchState:successor
                        completionHandler:^(NSError *error) {
                            if (error) {
                                NSLog(@"XXX: %@", error);
                            }
                        }];
    }
}


- (void)handleTurnEventForMatch:(SBAITurnBasedMatch *)match {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));

    [self.delegate handleTurnEventForMatch:match];

    // Wait 1 second, then see if we need to perform another move
    [self performSelector:@selector(performComputerMoveActionForMatch:) withObject:match afterDelay:1.0];
}


- (id <SBTurnBasedParticipant>)nextParticipantForMatch:(id <SBTurnBasedMatch>)match {
    return [self.delegate nextParticipantForMatch:match];
}

- (void)handleMatchEnded:(id <SBTurnBasedMatch>)match {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));
    [self.delegate handleMatchEnded:match];
}


@end