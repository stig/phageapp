//
//  SBMatchServiceTest.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "SBMatchService.h"
#import "SBMatch.h"
#import "SBPlayer.h"

@interface SBMatchServiceTest : SenTestCase {
	SBMatchService *service;
    SBMatch *match1, *match2, *match3;
}
@end


@implementation SBMatchServiceTest

- (void)setUp {
    SBPlayer *foo = [SBPlayer playerWithAlias:@"Foo"];
    SBPlayer *bar = [SBPlayer playerWithAlias:@"Bar"];

    match1 = [SBMatch matchWithPlayerOne:foo two:bar];
    match2 = [SBMatch matchWithPlayerOne:bar two:foo];
    match3 = [SBMatch matchWithPlayerOne:foo two:foo];

    service = [SBMatchService new];

    NSError *error;
    if (![[NSFileManager defaultManager] removeItemAtPath:[service savedMatchesPath] error:&error])
        @throw error;

}

- (void)testAllMatchesEmpty {
    STAssertEqualObjects(@[], [service allMatches], nil);
}

NSArray *desc(NSArray *array) {
    return [array valueForKey:@"description"];
}

- (void)testAllMatchesContainsOneMatch {
    [service saveMatch:match1];
    STAssertEqualObjects(@[match1.description], desc([service allMatches]), nil);
}

- (void)testAllMatchesContainsTwoMatches {
    [service saveMatch:match1];
    [service saveMatch:match2];
    STAssertEqualObjects(desc(@[match2, match1]), desc([service allMatches]), nil);
}

- (void)testAllMatchesContainsThreeMatches {
    [service saveMatch:match3];
    [service saveMatch:match1];
    [service saveMatch:match2];
    STAssertEqualObjects(desc(@[match3, match2, match1]), desc([service allMatches]), nil);
}

@end
