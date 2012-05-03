//
//  Created by s.brautaset@london.net-a-porter.com on 27/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

#import "SBTurnBasedMatchHelper.h"
#import "SBAITurnBasedMatch.h"

@interface SBAITurnBasedAdapter : NSObject <SBTurnBasedMatchHelperAdapter, SBAITurnBasedMatchDelegate>
@property(weak) SBTurnBasedMatchHelper *delegate;
@end