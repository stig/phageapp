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
    match.participants = [[NSArray alloc] initWithObjects:player1, player2, nil];
    match.matchState = [[SBState alloc] init];
    match.localParticipant = player1;
    match.currentParticipant = player1;
    return match;
}

- (NSString*)savedMatchFilePath {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [rootPath stringByAppendingPathComponent:@"SavedGame.dat"];
}

- (SBAITurnBasedMatch *)findSavedMatch {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self savedMatchFilePath]];
}

- (void)removeOldMatch {
    [[NSFileManager defaultManager] removeItemAtPath:[self savedMatchFilePath] error:nil];
}

- (void)saveMatch:(SBAITurnBasedMatch *)match {
    if ([NSKeyedArchiver archiveRootObject:match toFile:[self savedMatchFilePath]]) {
        NSLog(@"Failed to save game");
    }

}

- (void)findMatch {
    NSLog(@"-[%@ %@]", NSStringFromClass([self class]), NSStringFromSelector(_cmd));

    SBAITurnBasedMatch *match = [self findSavedMatch];
    if (!match) match = [self createMatch];

    match.delegate = self;

    self.currentMatch = match;

    [self.delegate handleDidFindMatch:match];
}

- (void)performComputerMoveActionForMatch:(SBAITurnBasedMatch*)match {
    NSLog(@"%s", sel_getName(_cmd));

    id move = [self.movePicker moveForState:match.matchState];
    NSAssert(move != nil, @"Should not be nil!");
    id successor = [match.matchState successorWithMove:move];
    [[[PhageModelHelper alloc] init] endTurnOrMatch:match withMatchState:successor completionHandler:^(NSError *error) {
    }];
}


- (void)handleTurnEventForMatch:(SBAITurnBasedMatch *)match {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));

    [self.delegate handleTurnEventForMatch:match];
    [self saveMatch:match];

    if (![self.delegate isLocalPlayerTurn:match]) {
        // Wait 1 second then perform a move on behalf of the computer.
        [self performSelector:@selector(performComputerMoveActionForMatch:) withObject:match afterDelay:1.0];
    }
}

- (void)handleMatchEnded:(SBAITurnBasedMatch *)match {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));
    [self.delegate handleMatchEnded:match];
    [self removeOldMatch];
}


@end