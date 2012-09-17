//
// Created by SuperPappi on 19/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

@class SBPlayer;
@class SBBoard;
@class SBMove;
@class SBPiece;

@interface SBMatch : NSObject

@property(nonatomic, readonly) NSString *matchID;
@property(nonatomic, readonly) NSDate *lastUpdated;
@property(nonatomic, readonly, getter=isGameOver) BOOL gameOver;
@property(nonatomic, readonly) SBPlayer *winner;
@property(nonatomic, readonly) SBPlayer *currentPlayer;
@property(nonatomic, readonly) SBPlayer *playerOne;
@property(nonatomic, readonly) SBPlayer *playerTwo;
@property(readonly) SBBoard *board; // atomic

+ (id)matchWithPlayerOne:(SBPlayer *)one two:(SBPlayer *)two;
+ (id)matchWithPlayerOne:(SBPlayer *)one two:(SBPlayer *)two board:(SBBoard *)board;

+ (id)matchWithPropertyList:(NSDictionary *)plist;
- (NSDictionary *)toPropertyList;

- (BOOL)isLegalMove:(SBMove *)aMove;

- (void)performMove:(SBMove *)move completionHandler:(void (^)(NSError *))completionHandler;

- (BOOL)canCurrentPlayerMovePiece:(SBPiece *)piece;

- (void)forfeit;

@end