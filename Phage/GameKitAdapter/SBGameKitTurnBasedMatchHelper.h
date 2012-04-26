//
//  Created by stig on 26/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "SBTurnBasedMatchHelper.h"
#import "SBGameKitTurnBasedMatchHelperInternal.h"

@interface SBGameKitTurnBasedMatchHelper : NSObject <SBTurnBasedMatchHelper, SBGameKitTurnBasedMatchHelperInternalDelegate>
- (id)initWithTurnBasedMatchHelper:(SBGameKitTurnBasedMatchHelperInternal *)helper;
@end