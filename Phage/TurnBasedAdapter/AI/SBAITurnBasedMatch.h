//
//  Created by s.brautaset@london.net-a-porter.com on 27/04/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>
#import "SBTurnBasedMatch.h"

@protocol SBTurnBasedMatchAdapterDelegate;

@interface SBAITurnBasedMatch : NSObject < SBTurnBasedMatch >

@property(strong) id<SBTurnBasedMatchAdapterDelegate> delegate;
@property(strong) id matchState;
@property(strong) NSArray *participants;

@end