//
// Created by SuperPappi on 20/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//



#import <SenTestingKit/SenTestingKit.h>
#import "SBPlayer.h"

@interface SBPlayerTest : SenTestCase
@end

@implementation SBPlayerTest

- (void)testPlayer {
    SBPlayer *player = [SBPlayer player];
    STAssertNil(player.alias, nil);
}

- (void)testPlayerWithAlias {
    SBPlayer *player = [SBPlayer playerWithAlias:@"Foo"];
    STAssertEqualObjects(player.alias, @"Foo", nil);
}

- (void)testIsLocalHuman {
    SBPlayer *player = [SBPlayer player];
    STAssertFalse(player.isLocalHuman, nil);
}

- (void)testCoder {
    SBPlayer *player = [SBPlayer playerWithAlias:@"foo"];
    player.eloScore = 1230;
    player.matchCount = 23;
    player.localHuman = YES;
    player.outcome = SBPlayerOutcomeLost;

    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:player];
    SBPlayer *other = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    STAssertEquals(other.eloScore, 1230u, nil);
    STAssertEquals(other.matchCount, 23u, nil);
    STAssertTrue(other.isLocalHuman, nil);
    STAssertEquals(other.outcome, SBPlayerOutcomeLost, nil);
    STAssertEqualObjects(other.alias, @"foo", nil);
}

@end