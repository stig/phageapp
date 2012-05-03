//
//  Created by s.brautaset@london.net-a-porter.com on 27/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "SBTurnBasedMatch.h"

@class SBAITurnBasedAdapter;

@protocol SBAITurnBasedMatchDelegate
@end

@interface SBAITurnBasedMatch : NSObject < SBTurnBasedMatch >

- (id)initWithMatchState:(id)matchState participants:(NSArray *)participants delegate:(id<SBAITurnBasedMatchDelegate>)delegate;

@end