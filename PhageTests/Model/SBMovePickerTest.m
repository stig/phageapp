//
//  Created by s.brautaset@london.net-a-porter.com on 30/03/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <SenTestingKit/SenTestingKit.h>
#import "SBMovePicker.h"
#import "SBState.h"
#import "SBMove.h"
#import "SBLocation.h"
#import "SBTrianglePiece.h"

@interface SBMovePickerTest : SenTestCase
@end

@implementation SBMovePickerTest

- (void)testInitialState {
    SBMovePicker *picker = [[SBMovePicker alloc] init];
    SBState *state = [[SBState alloc] init];

    SBMove *move = [picker moveForState:state];
    STAssertNotNil(move, nil);

    SBPiece *piece = [[SBTrianglePiece alloc] init];
    SBLocation *location = [[SBLocation alloc] initWithColumn:5 row:3];
    STAssertEqualObjects(move, [[SBMove alloc] initWithPiece:piece to:location], nil);
}


@end