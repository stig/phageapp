//
//  Created by s.brautaset@london.net-a-porter.com on 30/03/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <SenTestingKit/SenTestingKit.h>
#import "SBOpponentMobilityMinimisingMovePicker.h"
#import "SBBoard.h"
#import "SBMove.h"
#import "SBLocation.h"

@interface SBOpponentMobilityMinimisingMovePickerTest : SenTestCase
@end

@implementation SBOpponentMobilityMinimisingMovePickerTest

- (void)test {
    SBOpponentMobilityMinimisingMovePicker *picker = [[SBOpponentMobilityMinimisingMovePicker alloc] init];
    SBBoard *state = [SBBoard board];

    SBMove *move = [picker moveForState:state];
    STAssertNotNil(move, nil);

    SBLocation *from = [SBLocation locationWithColumn:3 row:5];
    SBLocation *to = [SBLocation locationWithColumn:5 row:3];
    STAssertEqualObjects(move, [SBMove moveWithFrom:from to:to], nil);
}


@end
