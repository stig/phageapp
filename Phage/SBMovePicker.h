//
//  Created by s.brautaset@london.net-a-porter.com on 30/03/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>

@class SBState;
@class SBMove;


@interface SBMovePicker : NSObject

- (SBMove *)optimalMoveForState:(SBState*)state;

@end