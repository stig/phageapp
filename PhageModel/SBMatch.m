//
// Created by SuperPappi on 19/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBMatch.h"
#import "SBBoard.h"
#import "SBPlayer.h"
#import "SBMove.h"

static NSString *const VERSION = @"Version";
static NSString *const MATCH_ID = @"MatchID";
static NSString *const PLAYER1 = @"Player1";
static NSString *const PLAYER2 = @"Player2";
static NSString *const BOARD = @"Board";
static NSString *const LAST_UPDATED = @"LastUpdated";

@implementation SBMatch

+ (id)matchWithPlayerOne:(SBPlayer *)one two:(SBPlayer *)two {
    return [[self alloc] initWithPlayerOne:one two:two];
}

- (id)initWithPlayerOne:(SBPlayer *)one two:(SBPlayer *)two {
    return [self initWithPlayerOne:one two:two board:[SBBoard board]];
}

+ (id)matchWithPlayerOne:(SBPlayer *)one two:(SBPlayer *)two board:(SBBoard *)board {
    return [[self alloc] initWithPlayerOne:one two:two board:board];
}

+ (id)matchWithPropertyList:(NSDictionary *)plist {
    if (![[plist objectForKey:VERSION] isEqual:@1])
        return nil;

    SBPlayer *one = [SBPlayer playerFromPropertyList:[plist objectForKey:PLAYER1]];
    SBPlayer *two = [SBPlayer playerFromPropertyList:[plist objectForKey:PLAYER2]];
    SBBoard *board = [SBBoard boardFromPropertyList:[plist objectForKey:BOARD]];
    NSString *matchID = [plist objectForKey:MATCH_ID];
    NSDate *lastUpdated = [NSDate dateWithTimeIntervalSince1970:[[plist objectForKey:LAST_UPDATED] doubleValue]];
    
    return [[self alloc] initWithPlayerOne:one two:two board:board matchID:matchID lastUpdated:lastUpdated];
}

- (NSDictionary *)toPropertyList {
    return @{
        VERSION: @1,
        MATCH_ID: self.matchID,
        PLAYER1: [self.playerOne toPropertyList],
        PLAYER2: [self.playerTwo toPropertyList],
        BOARD: [self.board toPropertyList],
        LAST_UPDATED: @(self.lastUpdated.timeIntervalSince1970)
    };
}


- (id)initWithPlayerOne:(SBPlayer *)one two:(SBPlayer *)two board:(SBBoard *)board {
    return [self initWithPlayerOne:one
                               two:two
                             board:board
                           matchID:[self createUUID]
                       lastUpdated:[NSDate date]];
}

- (NSString *)createUUID {
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    NSString *uuidStr = (__bridge_transfer NSString*)CFUUIDCreateString(NULL, uuid);
    CFRelease((CFTypeRef)uuid);
    return uuidStr;
}

- (id)initWithPlayerOne:(SBPlayer*)one two:(SBPlayer *)two board:(SBBoard*)board matchID:(NSString *)matchID lastUpdated:(NSDate *)lastUpdated {
    self = [super init];
    if (self) {
        _matchID = matchID;
        _playerOne = one;
        _playerTwo = two;
        _board = board;
        _lastUpdated = lastUpdated;
    }
    return self;
}

- (SBPlayer *)currentPlayer {
    return 0 == self.board.currentPlayerIndex ? self.playerOne : self.playerTwo;
}

- (BOOL)isLegalMove:(SBMove*)aMove {
    return [self.board isLegalMove:aMove];
}

- (void)performMove:(SBMove *)move completionHandler:(void (^)(NSError *))completionHandler {
    @synchronized (self) {
        NSError *error = nil;
        if ([self isLegalMove:move]) {
            _board = [self.board successorWithMove:move];
            if (self.board.isGameOver) {
                [self handleGameOver];
            }
            _lastUpdated = [NSDate date];
        } else {
            error = [NSError errorWithDomain:@"org.brautaset.Phage" code:1
                                    userInfo:@{ NSLocalizedDescriptionKey : @"Illegal move attempted"}];
        }

        if (completionHandler) completionHandler(error);
    }
}

- (void)setCurrentPlayerOutcome:(SBPlayerOutcome)cpo otherPlayerOutcome:(SBPlayerOutcome)opo {
    if ([self.currentPlayer isEqual:self.playerOne]) {
        _playerOne = [_playerOne playerWithOutcome:cpo];
        _playerTwo = [_playerTwo playerWithOutcome:opo];
    } else {
        _playerOne = [_playerOne playerWithOutcome:opo];
        _playerTwo = [_playerTwo playerWithOutcome:cpo];
    }
}


- (void)forfeit {
    @synchronized (self) {
        [self setCurrentPlayerOutcome:SBPlayerOutcomeQuit otherPlayerOutcome:SBPlayerOutcomeWon];
        _lastUpdated = [NSDate date];
    }
}

- (void)handleGameOver {
    if (self.board.isDraw) {
        [self setCurrentPlayerOutcome:SBPlayerOutcomeTied otherPlayerOutcome:SBPlayerOutcomeTied];
    } else {
        [self setCurrentPlayerOutcome:SBPlayerOutcomeLost otherPlayerOutcome:SBPlayerOutcomeWon];
    }
}

- (BOOL)isGameOver {
    return self.playerOne.outcome != SBPlayerOutcomeNone
        || self.playerTwo.outcome != SBPlayerOutcomeNone;
}

- (SBPlayer *)winner {
    if (self.playerOne.outcome == SBPlayerOutcomeWon)
        return self.playerOne;
    else if (self.playerTwo.outcome == SBPlayerOutcomeWon)
        return self.playerTwo;
    return nil;
}

- (BOOL)canCurrentPlayerMovePiece:(SBPiece *)piece {
    __block BOOL ret = NO;
    [self.board enumerateLegalMovesWithBlock:^void(SBMove *move, BOOL *stop) {
        SBPiece *p = [self.board pieceForLocation:move.from];
        if ([piece isEqual:p]) {
            ret = YES;
            *stop = YES;
        }
    }];
    return ret;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"%@ vs %@ (%u moves in)", self.playerOne.alias, self.playerTwo.alias, self.board.moveHistory.count];
}


@end