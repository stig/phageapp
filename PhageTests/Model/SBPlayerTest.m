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

@end