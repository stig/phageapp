//
//  Created by s.brautaset@london.net-a-porter.com on 27/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "SBTurnBasedMatchHelper.h"
#import "SBAITurnBasedMatch.h"

@class SBMovePicker;

@interface SBAITurnBasedAdapter : NSObject <SBTurnBasedMatchAdapter, SBTurnBasedMatchAdapterDelegate>
@property(strong) SBTurnBasedMatchHelper *delegate;
@property(strong) SBMovePicker *movePicker;
@end