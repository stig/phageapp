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
@synthesize players = _players;
@synthesize board = _board;


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

    _players = [NSArray arrayWithObjects:one, two, nil];
    _board = board;
    return self;
}

- (id<SBPlayer>)currentPlayer {
    return [self.players objectAtIndex:self.board.currentPlayerIndex];
}

- (BOOL)isLegalMove:(SBMove*)aMove {
    return [self.board isLegalMove:aMove];
}

- (void)performMove:(SBMove *)move {
    _board = [self.board successorWithMove:move];
}

- (BOOL)isGameOver {
    return [self.board isGameOver];
}

- (id <SBPlayer>)winner {
    if ([self.board isDraw])
        return nil;
    return [self.players objectAtIndex:self.board.otherPlayerIndex];
}

@end