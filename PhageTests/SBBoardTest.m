//
//  SBBoardTest.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBBoardTest.h"
#import "SBBoard.h"


@implementation SBBoardTest

- (void)testEquals {
    SBBoard *a = [[SBBoard alloc] init];
    STAssertEqualObjects(a, a, nil);
    
    SBBoard *b = [[SBBoard alloc] init];
    STAssertEqualObjects(a, b, nil);
}

- (void)testHash {
    SBBoard *a = [[SBBoard alloc] init];    
    SBBoard *b = [[SBBoard alloc] init];
    STAssertEquals([a hash], [b hash], nil);
}

@end
