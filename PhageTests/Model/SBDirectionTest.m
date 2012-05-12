#import <SenTestingKit/SenTestingKit.h>
#import "SBDirection.h"

@interface SBDirectionTest : SenTestCase
@end

@implementation SBDirectionTest

static SBDirection *dir;

- (void)setUp {
    dir = [[SBDirection alloc] initWithColumn:1 row:-1];
}

- (void)testBasic {
    STAssertNotNil(dir, nil);
    
    STAssertEquals(dir.column, 1, nil);
    STAssertEquals(dir.row, -1, nil);
}

- (void)testEqual {
    STAssertEqualObjects(dir, dir, nil);

    SBDirection *b = [[SBDirection alloc] initWithColumn:dir.column row:dir.row];
    STAssertEqualObjects(dir, b, nil);
}

- (void)testHash {
    SBDirection *b = [[SBDirection alloc] initWithColumn:dir.column row:dir.row];
    STAssertEquals([dir hash], [b hash], nil);
}


- (void)testDescription {
    STAssertEqualObjects(@"<1,-1>", [dir description], nil);
}

@end
