//
// Created by SuperPappi on 19/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//



@class SBPhageBoard;
@protocol SBPlayer;

@interface SBPhageMatch : NSObject

@property(nonatomic, readonly) id<SBPlayer> currentPlayer;
@property(nonatomic, readonly) NSArray *players;
@property(nonatomic, readonly) SBPhageBoard *board;

+ (id)matchWithPlayerOne:(id<SBPlayer>)one two:(id<SBPlayer>)two;
- (id)initWithPlayerOne:(id<SBPlayer>)one two:(id<SBPlayer>)two;

@end