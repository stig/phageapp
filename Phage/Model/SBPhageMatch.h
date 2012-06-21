//
// Created by SuperPappi on 19/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//



@protocol SBPlayer;
@class SBPhageBoard;
@class SBMove;
@class SBPiece;

@interface SBPhageMatch : NSObject

@property(nonatomic, readonly) BOOL isGameOver;
@property(nonatomic, readonly) id<SBPlayer> winner;
@property(nonatomic, readonly) id<SBPlayer> currentPlayer;
@property(nonatomic, readonly) id<SBPlayer> playerOne;
@property(nonatomic, readonly) id<SBPlayer> playerTwo;
@property(nonatomic, readonly) SBPhageBoard *board;

+ (id)matchWithPlayerOne:(id<SBPlayer>)one two:(id<SBPlayer>)two;
- (id)initWithPlayerOne:(id<SBPlayer>)one two:(id<SBPlayer>)two;

+ (id)matchWithPlayerOne:(id<SBPlayer>)one two:(id<SBPlayer>)two board:(SBPhageBoard *)board;
- (id)initWithPlayerOne:(id<SBPlayer>)one two:(id<SBPlayer>)two board:(SBPhageBoard *)board;

- (BOOL)isLegalMove:(SBMove *)aMove;
- (void)performMove:(SBMove*)move;

- (BOOL)canCurrentPlayerMovePiece:(SBPiece *)piece;

@end