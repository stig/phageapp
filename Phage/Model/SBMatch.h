//
// Created by SuperPappi on 19/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//



@protocol SBPlayer;
@class SBBoard;
@class SBMove;
@class SBPiece;

@interface SBMatch : NSObject

@property(nonatomic, readonly) NSDate *lastUpdated;
@property(nonatomic, readonly, getter=isGameOver) BOOL gameOver;
@property(nonatomic, readonly) id<SBPlayer> winner;
@property(nonatomic, readonly) id<SBPlayer> currentPlayer;
@property(nonatomic, readonly) id<SBPlayer> playerOne;
@property(nonatomic, readonly) id<SBPlayer> playerTwo;
@property(readonly) SBBoard *board; // atomic

+ (id)matchWithPlayerOne:(id<SBPlayer>)one two:(id<SBPlayer>)two;
- (id)initWithPlayerOne:(id<SBPlayer>)one two:(id<SBPlayer>)two;

+ (id)matchWithPlayerOne:(id<SBPlayer>)one two:(id<SBPlayer>)two board:(SBBoard *)board;
- (id)initWithPlayerOne:(id<SBPlayer>)one two:(id<SBPlayer>)two board:(SBBoard *)board;

- (BOOL)isLegalMove:(SBMove *)aMove;

- (void)performMove:(SBMove *)move completionHandler:(void (^)(NSError *))completionHandler;

- (BOOL)canCurrentPlayerMovePiece:(SBPiece *)piece;

- (void)forfeit;

@end