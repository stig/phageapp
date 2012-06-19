//
// Created by SuperPappi on 19/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <SenTestingKit/SenTestingKit.h>
#import <OCMock/OCMock.h>
#import "SBPhageMatch.h"
#import "SBPlayer.h"
#import "SBPhageBoard.h"

@interface SBPhageMatchTest : SenTestCase {
    SBPhageMatch *match;
    id one;
    id two;
}
@end

@implementation SBPhageMatchTest

- (void)setUp {
    one = [OCMockObject mockForProtocol:@protocol(SBPlayer)];
    two = [OCMockObject mockForProtocol:@protocol(SBPlayer)];
    match = [SBPhageMatch matchWithPlayerOne:one two:two];
}

- (void)testInit {
    STAssertNotNil(match, nil);
    STAssertEqualObjects(match.currentPlayer, one, nil);
    STAssertEqualObjects(match.board, [SBPhageBoard board], nil);
    STAssertEqualObjects([match.players objectAtIndex:0], one, nil);
    STAssertEqualObjects([match.players objectAtIndex:1], two, nil);
}

@end