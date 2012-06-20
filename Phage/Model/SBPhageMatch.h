//
// Created by SuperPappi on 19/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//



@class SBPhageBoard;
@protocol SBPlayer;
@class SBMove;

@interface SBPhageMatch : NSObject

@property(nonatomic, readonly) id<SBPlayer> currentPlayer;
@property(nonatomic, readonly) NSArray *players;
@property(nonatomic, readonly) SBPhageBoard *board;

+ (id)matchWithPlayerOne:(id<SBPlayer>)one two:(id<SBPlayer>)two;
- (id)initWithPlayerOne:(id<SBPlayer>)one two:(id<SBPlayer>)two;

+ (id)matchWithPlayerOne:(id<SBPlayer>)one two:(id<SBPlayer>)two board:(SBPhageBoard *)board;
- (id)initWithPlayerOne:(id<SBPlayer>)one two:(id<SBPlayer>)two board:(SBPhageBoard *)board;

- (BOOL)isLegalMove:(SBMove *)aMove;
- (void)transitionToSuccessorWithMove:(SBMove*)move;

- (BOOL)isGameOver;
- (id<SBPlayer>)winner;

@end