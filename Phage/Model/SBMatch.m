//
// Created by SuperPappi on 19/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBMatch.h"
#import "SBBoard.h"
#import "SBPlayer.h"
#import "SBMove.h"

@implementation SBMatch
@synthesize board = _board;
@synthesize playerOne = _playerOne;
@synthesize playerTwo = _playerTwo;
@synthesize lastUpdated = _lastUpdated;


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
    self = [super init];
    if (!self) return nil;

    _playerOne = one;
    _playerTwo = two;
    _board = board;
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

- (void)forfeit {
    @synchronized (self) {
        self.currentPlayer.outcome = SBPlayerOutcomeQuit;
        self.otherPlayer.outcome = SBPlayerOutcomeWon;
        _lastUpdated = [NSDate date];
    }
}

- (void)handleGameOver {
    if (self.board.isDraw) {
        self.playerOne.outcome = self.playerTwo.outcome = SBPlayerOutcomeTied;
    } else {
        self.currentPlayer.outcome = SBPlayerOutcomeLost;
        self.otherPlayer.outcome = SBPlayerOutcomeWon;
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


@end