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
#import "PhageModelHelper.h"

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

- (SBAITurnBasedMatch *)createMatch {
    SBAITurnBasedParticipant *player1 = [[SBAITurnBasedParticipant alloc] initWithPlayerID:@"human"];
    SBAITurnBasedParticipant *player2 = [[SBAITurnBasedParticipant alloc] initWithPlayerID:@"ai"];

    SBAITurnBasedMatch *match = [[SBAITurnBasedMatch alloc] init];
    match.participants = [NSArray arrayWithObjects:player1, player2, nil];
    match.matchState = nil;
    match.localParticipant = player1;
    match.currentParticipant = player1;
    return match;
}

- (NSString*)savedMatchFilePath {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [rootPath stringByAppendingPathComponent:@"SavedComputerMatch.dat"];
}

- (SBAITurnBasedMatch *)findSavedMatch {
    @synchronized (self) {
        return [NSKeyedUnarchiver unarchiveObjectWithFile:[self savedMatchFilePath]];
    }
}

- (void)removeOldMatch {
    [[NSFileManager defaultManager] removeItemAtPath:[self savedMatchFilePath] error:nil];
}

- (void)saveMatch:(SBAITurnBasedMatch *)match {
    @synchronized (self) {
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:match];
        NSError *error = nil;
        if (![data writeToFile:self.savedMatchFilePath options:NSDataWritingAtomic error:&error]) {
            TFLog(@"%s Failed to save match: %@", __PRETTY_FUNCTION__, error);
        }
    }
}

- (void)maybePerformComputerMoveForMatch:(SBAITurnBasedMatch *)match {
    if (![self.delegate isLocalPlayerTurn:match]) {
        // Wait 1 second then perform a move on behalf of the computer.
        [self performSelector:@selector(performComputerMoveActionForMatch:) withObject:match afterDelay:1.0];
    }
}

- (void)findMatch {
    SBAITurnBasedMatch *match = [self findSavedMatch];
    if (!match) match = [self createMatch];

    match.delegate = self;

    self.currentMatch = match;

    [self.delegate handleDidFindMatch:match];

    [self maybePerformComputerMoveForMatch:match];
}

- (void)performComputerMoveActionForMatch:(SBAITurnBasedMatch*)match {
    id move = [self.movePicker moveForState:match.matchState];
    NSAssert(move != nil, @"Should not be nil!");
    id successor = [match.matchState successorWithMove:move];
    [[[PhageModelHelper alloc] init] endTurnOrMatch:match withMatchState:successor completionHandler:NULL];
}

- (void)handleTurnEventForMatch:(SBAITurnBasedMatch *)match {
    [self.delegate handleTurnEventForMatch:match];
    [self saveMatch:match];

    [self maybePerformComputerMoveForMatch:match];
}

- (void)handleMatchEnded:(SBAITurnBasedMatch *)match {
    [TestFlight passCheckpoint:@"FINISH_ONE_PLAYER_MATCH"];

    [self.delegate handleMatchEnded:match];
    [self removeOldMatch];
}


@end