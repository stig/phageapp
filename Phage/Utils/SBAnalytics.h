//
// Created by SuperPappi on 08/10/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//



@interface SBAnalytics : NSObject

+ (void)logEvent:(NSString *)event;
+ (void)logEvent:(NSString *)event withParameters:(NSDictionary *)params;

@end