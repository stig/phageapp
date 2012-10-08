//
// Created by SuperPappi on 09/10/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//



#import "SBPlayer.h"

@interface SBBot : NSObject < SBPlayer >

+ (id)bot;
+ (id)botWithAlias:(NSString *)alias;

@end