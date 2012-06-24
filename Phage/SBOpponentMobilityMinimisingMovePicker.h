//
//  Created by s.brautaset@london.net-a-porter.com on 30/03/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "SBPiece.h"

@class SBBoard;
@class SBMove;


@interface SBOpponentMobilityMinimisingMovePicker : NSObject

- (SBMove *)moveForState:(SBBoard *)state;

@end