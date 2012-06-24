//
// Created by SuperPappi on 20/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//



#import <SenTestingKit/SenTestingKit.h>
#import "SBHuman.h"

@interface SBHumanTest : SenTestCase {
    SBHuman *player;
}
@end

@implementation SBHumanTest

- (void)setUp {
    player = [SBHuman playerWithAlias:@"Foo"];
}

- (void)testAlias {
    STAssertEqualObjects(player.alias, @"Foo", nil);
}

- (void)testIsLocalHuman {
    STAssertTrue(player.isLocalHuman, nil);
}

@end