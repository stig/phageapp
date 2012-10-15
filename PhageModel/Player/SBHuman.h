//
// Created by SuperPappi on 20/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//



#import "SBPlayer.h"
#import "SBAbstractPlayer.h"

@interface SBHuman : SBAbstractPlayer <SBPlayer>

+ (id)humanWithAlias:(NSString *)alias;

@end