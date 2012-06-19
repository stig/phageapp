//
// Created by SuperPappi on 12/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class SBPhageBoard;
@protocol SBTurnBasedMatch;
@protocol SBTurnBasedParticipant;

@interface PhageModelHelper : NSObject
- (id<SBTurnBasedParticipant>)nextParticipantForMatch:(id<SBTurnBasedMatch>)match;

- (void)endTurnOrMatch:(id <SBTurnBasedMatch>)match withMatchState:(SBPhageBoard *)successor completionHandler:(void(^)(NSError *))completionHandler;

- (void)forfeitMatch:(id <SBTurnBasedMatch>)match inTurnWithCompletionHandler:(void (^)(NSError *))completionHandler;

@end