//
//  NSArrayUtilsTest.m
//  NSArrayUtilsTest
//
//  Created by Stig Brautaset on 20/08/2012.
//
//

#import <SenTestingKit/SenTestingKit.h>
#import "NSArray+Utils.h"

@interface NSArrayUtilsTest : SenTestCase
@end

@implementation NSArrayUtilsTest

- (void)testApply {
    NSArray *input = [@"fi fo fa fum" componentsSeparatedByString:@" "];
    NSArray *expected = [@"fifi fofo fafa fumfum" componentsSeparatedByString:@" "];

    NSArray *output = [input applyBlock:^id(id o) {
        return [NSString stringWithFormat:@"%@%@", o, o];
    }];

    STAssertEqualObjects(output, expected, nil);
}

@end
