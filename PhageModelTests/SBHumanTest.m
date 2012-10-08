//
// Created by SuperPappi on 20/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//



#import <SenTestingKit/SenTestingKit.h>
#import "SBHuman.h"
#import "SBPlayerHelper.h"

@interface SBHumanTest : SenTestCase
@end

@implementation SBHumanTest

- (void)testPlayer {
    SBHuman *player = [SBHuman humanWithAlias:@""];
    STAssertNil(player.alias, nil);
}

- (void)testPlayerWithAlias {
    SBHuman *player = [SBHuman humanWithAlias:@"Foo"];
    STAssertEqualObjects(player.alias, @"Foo", nil);
}

- (void)testIsLocalHuman {
    SBHuman *player = [SBHuman humanWithAlias:@""];
    STAssertFalse(player.isHuman, nil);
}

- (void)testViaDictionary {
    SBHuman *player = [[SBHuman humanWithAlias:@"foo"] withOutcome:SBPlayerOutcomeLost];

    SBPlayerHelper *helper = [SBPlayerHelper helper];
    id<SBPlayer> other = [helper fromPropertyList:[helper toPropertyList:player]];

    STAssertTrue(other.isHuman, nil);
    STAssertEquals(other.outcome, SBPlayerOutcomeLost, nil);
    STAssertEqualObjects(other.alias, @"foo", nil);
}

@end