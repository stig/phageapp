//
//  Created by stig on 26/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "SBTurnBasedMatch.h"


@interface SBGameKitTurnBasedMatch : NSObject <SBTurnBasedMatch>
@property(readonly) GKTurnBasedMatch *wrappedMatch;
- (id)initWithMatch:(GKTurnBasedMatch*)match;
@end