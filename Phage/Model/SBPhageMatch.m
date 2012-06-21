//
// Created by SuperPappi on 19/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBPhageMatch.h"
#import "SBPhageBoard.h"
#import "SBPlayer.h"
#import "SBMove.h"

@implementation SBPhageMatch
@synthesize board = _board;
@synthesize playerOne = _playerOne;
@synthesize playerTwo = _playerTwo;


+ (id)matchWithPlayerOne:(id<SBPlayer>)one two:(id<SBPlayer>)two {
    return [[self alloc] initWithPlayerOne:one two:two];
}

- (id)initWithPlayerOne:(id<SBPlayer>)one two:(id<SBPlayer>)two {
    return [self initWithPlayerOne:one two:two board:[SBPhageBoard board]];
}

+ (id)matchWithPlayerOne:(id <SBPlayer>)one two:(id <SBPlayer>)two board:(SBPhageBoard *)board {
    return [[self alloc] initWithPlayerOne:one two:two board:board];
}

- (id)initWithPlayerOne:(id <SBPlayer>)one two:(id <SBPlayer>)two board:(SBPhageBoard *)board {
    self = [super init];
    if (!self) return nil;

    _playerOne = one;
    _playerTwo = two;
    _board = board;
    return self;
}

- (id<SBPlayer>)currentPlayer {
    return 0 == self.board.currentPlayerIndex ? self.playerOne : self.playerTwo;
}

- (id<SBPlayer>)otherPlayer {
    return [self.currentPlayer isEqual:self.playerOne] ? self.playerTwo : self.playerOne;
}

- (BOOL)isLegalMove:(SBMove*)aMove {
    return [self.board isLegalMove:aMove];
}

- (void)performMove:(SBMove *)move {
    @synchronized (self) {
        _board = [self.board successorWithMove:move];
        if (self.board.isGameOver) {
            [self handleGameOver];
        }
    }
}

- (void)forfeit {
    self.currentPlayer.outcome = SBPlayerOutcomeQuit;
    self.otherPlayer.outcome = SBPlayerOutcomeWon;
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

- (id <SBPlayer>)winner {
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