//
// Created by SuperPappi on 12/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class SBState;
@protocol SBTurnBasedMatch;
@protocol SBTurnBasedParticipant;

@interface PhageModelHelper : NSObject
- (id<SBTurnBasedParticipant>)nextParticipantForMatch:(id<SBTurnBasedMatch>)match;
- (void)endTurnOrMatch:(id <SBTurnBasedMatch>)match withMatchState:(SBState *)successor completionHandler:(void(^)(NSError*error))completionHandler;
@end