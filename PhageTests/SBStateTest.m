//
//  SBStateTest.m
//  Phage
//
//  Created by Stig Brautaset on 25/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBStateTest.h"
#import "SBSTate.h"

@implementation SBStateTest

- (void)testDescription {
    SBState *s = [[SBState alloc] init];
    STAssertEqualObjects([s description], @".......D\n.....T..\n...S....\n.C......\n......c.\n....s...\n..t.....\nd.......\n", nil);    
}


@end
