//
// Created by SuperPappi on 20/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//



#import <SenTestingKit/SenTestingKit.h>
#import "SBPlayer.h"

@interface SBPlayerTest : SenTestCase {
    SBPlayer *player;
}
@end

@implementation SBPlayerTest

- (void)setUp {
    player = [SBPlayer playerWithAlias:@"Foo"];
}

- (void)testAlias {
    STAssertEqualObjects(player.alias, @"Foo", nil);
}

- (void)testIsLocalHuman {
    STAssertFalse(player.isLocalHuman, nil);
}

@end