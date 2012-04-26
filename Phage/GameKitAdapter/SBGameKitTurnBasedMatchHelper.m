//
//  Created by stig on 26/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBGameKitTurnBasedMatchHelper.h"
#import "SBGameKitTurnBasedMatch.h"
#import "SBGameKitTurnBasedParticipant.h"

@implementation SBGameKitTurnBasedMatchHelper {
    SBGameKitTurnBasedMatchHelperInternal *_helper;
}

@synthesize delegate = _delegate;

- (id)initWithTurnBasedMatchHelper:(SBGameKitTurnBasedMatchHelperInternal *)helper {
    self = [super init];
    if (self) {
        _helper = helper;
    }
    return self;
}

- (id <SBTurnBasedMatch>)currentMatch {
    return [[SBGameKitTurnBasedMatch alloc] initWithMatch:_helper.currentMatch];
}

- (void)findMatch {
    [_helper findMatch];
}

- (BOOL)isLocalPlayerTurn:(id<SBTurnBasedMatch>)match {
    SBGameKitTurnBasedMatch *adapter = (SBGameKitTurnBasedMatch *)match;
    return [_helper isLocalPlayerTurn:adapter.wrappedMatch];
}

#pragma mark Private

- (SBGameKitTurnBasedMatch *)wrap:(GKTurnBasedMatch *)match {
    return [[SBGameKitTurnBasedMatch alloc] initWithMatch:match];
}

#pragma mark TurnBasedMatchHelperDelegate

- (void)enterNewGame:(GKTurnBasedMatch *)match {
    [_delegate enterNewGame:[self wrap:match]];
}

- (void)takeTurn:(GKTurnBasedMatch *)match {
    [_delegate takeTurn:[self wrap:match]];
}

- (void)layoutMatch:(GKTurnBasedMatch *)match {
    [_delegate layoutMatch:[self wrap:match]];
}

- (GKTurnBasedParticipant *)nextParticipantForMatch:(GKTurnBasedMatch *)match {
    SBGameKitTurnBasedParticipant *adapter = (SBGameKitTurnBasedParticipant *)[_delegate nextParticipantForMatch:[self wrap:match]];
    return adapter.wrappedParticipant;
}

- (void)receiveEndGame:(GKTurnBasedMatch *)match {
    [_delegate receiveEndGame:[self wrap:match]];
}

- (void)sendTitle:(NSString *)title notice:(NSString *)notice forMatch:(GKTurnBasedMatch *)match {
    [_delegate sendTitle:title notice:notice forMatch:[self wrap:match]];
}

@end