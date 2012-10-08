//
// Created by SuperPappi on 08/10/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBAnalytics.h"
#import "TestFlight.h"
#import "Flurry.h"


@implementation SBAnalytics

+ (void)logEvent:(NSString *)event {
    NSLog(@"event = %@", event);
    [Flurry logEvent:event];
    [TestFlight passCheckpoint:event];
}

+ (NSString *)stringifyDict:(NSDictionary *)dict {
    NSMutableArray *kv = [NSMutableArray array];
    for (id k in [[dict allKeys] sortedArrayUsingSelector:@selector(compare:)])
        [kv addObject:[NSString stringWithFormat:@"%@=%@", k, [dict objectForKey:k]]];
    return [kv componentsJoinedByString:@";"];
}

+ (void)logEvent:(NSString *)event withParameters:(NSDictionary *)params {
    NSString *p = [self stringifyDict:params];
    NSLog(@"event = %@, params = %@", event, p);
    [Flurry logEvent:event withParameters:params];
    [TestFlight passCheckpoint:[event stringByAppendingFormat:@"_%@", p]];
}


@end