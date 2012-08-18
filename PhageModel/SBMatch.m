//
// Created by SuperPappi on 19/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBMatch.h"
#import "SBBoard.h"
#import "SBPlayer.h"
#import "SBMove.h"

static NSInteger MatchVersion = 3;
static NSString *MatchVersionKey = @"v";
static NSString *PlayerOneKey = @"1";
static NSString *PlayerTwoKey = @"2";
static NSString *MoveHistoryKey = @"m";
static NSString *MatchIDKey = @"i";
static NSString *LastUpdatedKey = @"l";


@implementation SBMatch
@synthesize matchID = _matchID;
@synthesize board = _board;
@synthesize playerOne = _playerOne;
@synthesize playerTwo = _playerTwo;
@synthesize lastUpdated = _lastUpdated;



- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInteger:MatchVersion forKey:MatchVersionKey];
    [coder encodeObject:self.matchID forKey:MatchIDKey];
    [coder encodeObject:self.playerOne forKey:PlayerOneKey];
    [coder encodeObject:self.playerTwo forKey:PlayerTwoKey];
    [coder encodeObject:self.board.moveHistory forKey:MoveHistoryKey];
    [coder encodeObject:self.lastUpdated forKey:LastUpdatedKey];
}

- (id)initWithCoder:(NSCoder *)coder {
    if (![coder containsValueForKey:MatchVersionKey]) {
        NSLog(@"Unsupported match format");
        return nil;
    }

    NSInteger version = [coder decodeIntegerForKey:MatchVersionKey];
    if (version > MatchVersion) {
        NSLog(@"Unsupported match format; please upgrade your version of Phage!");
        return nil;
    }

    SBPlayer *one = [coder decodeObjectForKey:PlayerOneKey];
    SBPlayer *two = [coder decodeObjectForKey:PlayerTwoKey];
    SBBoard *board = [SBBoard boardWithMoveHistory:[coder decodeObjectForKey:MoveHistoryKey]];
    NSString *matchID = [coder decodeObjectForKey:MatchIDKey];
    NSDate *lastUpdated = [coder decodeObjectForKey:LastUpdatedKey];

    return  [self initWithPlayerOne:one two:two board:board matchID:matchID lastUpdated:lastUpdated];
}


+ (id)matchWithPlayerOne:(SBPlayer *)one two:(SBPlayer *)two {
    return [[self alloc] initWithPlayerOne:one two:two];
}

- (id)initWithPlayerOne:(SBPlayer *)one two:(SBPlayer *)two {
    return [self initWithPlayerOne:one two:two board:[SBBoard board]];
}

+ (id)matchWithPlayerOne:(SBPlayer *)one two:(SBPlayer *)two board:(SBBoard *)board {
    return [[self alloc] initWithPlayerOne:one two:two board:board];
}

- (id)initWithPlayerOne:(SBPlayer *)one two:(SBPlayer *)two board:(SBBoard *)board {
    return [self initWithPlayerOne:one
                               two:two
                             board:board
                           matchID:(__bridge NSString *) CFUUIDCreateString(NULL, CFUUIDCreate(NULL))
                       lastUpdated:[NSDate date]];
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

- (SBPlayer *)otherPlayer {
    return [self.currentPlayer isEqual:self.playerOne] ? self.playerTwo : self.playerOne;
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