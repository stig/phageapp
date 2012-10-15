//
// Created by SuperPappi on 15/10/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//



#import "SBPlayer.h"

@interface SBAbstractPlayer : NSObject

@property(readonly, copy) NSString *alias;
@property(readonly, copy) NSString *displayName;
@property(readonly) SBPlayerOutcome outcome;

+ (id)objectWithAlias:(NSString *)alias;
+ (id)objectWithAlias:(NSString *)alias displayName:(NSString *)displayName;
+ (id)objectWithAlias:(NSString *)alias displayName:(NSString *)displayName outcome:(SBPlayerOutcome)outcome;

- (id)withOutcome:(SBPlayerOutcome)outcome;

@end