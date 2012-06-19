//
// Created by SuperPappi on 19/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBPhageMatch.h"
#import "SBPhageBoard.h"
#import "SBPlayer.h"

@implementation SBPhageMatch
@synthesize players = _players;
@synthesize board = _board;


+ (id)matchWithPlayerOne:(id<SBPlayer>)one two:(id<SBPlayer>)two {
    return [[self alloc] initWithPlayerOne:one two:two];
}

- (id)initWithPlayerOne:(id<SBPlayer>)one two:(id<SBPlayer>)two {
    return [self initWithPlayerOne:one two:two moveHistory:[NSArray array]];
}

+ (id)matchWithPlayerOne:(id <SBPlayer>)one two:(id <SBPlayer>)two moveHistory:(NSArray *)moveHistory {
    return [[self alloc] initWithPlayerOne:one two:two moveHistory:moveHistory];
}

- (id)initWithPlayerOne:(id <SBPlayer>)one two:(id <SBPlayer>)two moveHistory:(NSArray *)moveHistory {
    self = [super init];
    if (!self) return nil;

    _players = [NSArray arrayWithObjects:one, two, nil];
    _board = [SBPhageBoard boardWithMoveHistory:moveHistory];
    return self;
}

- (id<SBPlayer>)currentPlayer {
    return [self.players objectAtIndex:self.board.currentPlayer];
}


@end