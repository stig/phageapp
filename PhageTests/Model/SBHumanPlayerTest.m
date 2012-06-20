//
// Created by SuperPappi on 20/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//



#import <SenTestingKit/SenTestingKit.h>
#import "SBHumanPlayer.h"

@interface SBHumanPlayerTest : SenTestCase {
    SBHumanPlayer *player;
}
@end

@implementation SBHumanPlayerTest

- (void)setUp {
    player = [SBHumanPlayer playerWithAlias:@"Foo"];
}

- (void)testAlias {
    STAssertEqualObjects(player.alias, @"Foo", nil);
}

- (void)testIsLocalHuman {
    STAssertTrue(player.isLocalHuman, nil);
}

@end