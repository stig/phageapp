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
    
    NSArray *expected = [[NSArray alloc] initWithObjects:
                         @"C: 7",
                         @"S: 7",
                         @"T: 7",
                         @"D: 7",
                         @".......D",
                         @".....T..",
                         @"...S....",
                         @".C......",
                         @"......c.",
                         @"....s...",
                         @"..t.....",
                         @"d.......",
                         @"c: 7",
                         @"s: 7",
                         @"t: 7",
                         @"d: 7",
                         @"",
                         nil];
    
    STAssertEqualObjects([s description], [expected componentsJoinedByString:@"\n"], nil);
}


@end
