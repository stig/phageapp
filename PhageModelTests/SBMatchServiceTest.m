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

SBMatch *match(NSString *a, NSString *b) {
    SBPlayer *foo = [SBPlayer playerWithAlias:a];
    SBPlayer *bar = [SBPlayer playerWithAlias:b];
    return [SBMatch matchWithPlayerOne:foo two:bar];
}


- (void)setUp {
    match1 = match(@"Foo", @"Bar");
    match2 = match(@"Bar", @"Foo"); [match2 forfeit];
    match3 = match(@"Baz", @"Quux");

    service = [SBMatchService matchService];

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

- (void)testActiveMatchesContainsTwoMatches {
    [service saveMatch:match3];
    [service saveMatch:match1];
    [service saveMatch:match2];
    STAssertEqualObjects(desc([service activeMatches]), desc(@[match3, match1]), nil);
}

- (void)testInactiveMatchesContainsOneMatch {
    [service saveMatch:match1];
    [service saveMatch:match2];
    [service saveMatch:match3];
    STAssertEqualObjects(desc([service inactiveMatches]), desc(@[match2]), nil);
}

- (void)testDeleteMatchInProgressThrows {
    STAssertThrows([service deleteMatch:match1], nil);
}

- (void)testDeleteUnsavedMatchDoesNotThrow {
    STAssertNoThrow([service deleteMatch:match2], nil);
}

- (void)testDeleteMatchRemovesFromAllMatches {
    [service saveMatch:match2];
    STAssertNoThrow([service deleteMatch:match2], nil);
    STAssertEqualObjects(@[], [service allMatches], nil);
}


@end
