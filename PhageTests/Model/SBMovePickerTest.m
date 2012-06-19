//
//  Created by s.brautaset@london.net-a-porter.com on 30/03/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <SenTestingKit/SenTestingKit.h>
#import "SBMovePicker.h"
#import "SBPhageBoard.h"
#import "SBMove.h"
#import "SBLocation.h"

@interface SBMovePickerTest : SenTestCase
@end

@implementation SBMovePickerTest

- (void)testInitialState {
    SBMovePicker *picker = [[SBMovePicker alloc] init];
    SBPhageBoard *state = [SBPhageBoard board];

    SBMove *move = [picker moveForState:state];
    STAssertNotNil(move, nil);

    SBLocation *from = [SBLocation locationWithColumn:3 row:5];
    SBLocation *to = [SBLocation locationWithColumn:5 row:3];
    STAssertEqualObjects(move, [SBMove moveWithFrom:from to:to], nil);
}


@end
