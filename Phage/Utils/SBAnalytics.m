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
    [self logEvent:event withParameters:nil];
}

+ (void)logEvent:(NSString *)event withParameters:(NSDictionary *)params {
    [self logEvent:event withParameters:params timed:NO];
}

+ (void)logEvent:(NSString *)event withParameters:(NSDictionary *)params timed:(BOOL)timed {
    NSLog(@"event = %@, timed: %@, params = %@", event, @(timed), params);
    [Flurry logEvent:event withParameters:params timed:timed];

    // TestFlight doesn't take arguments, so we have to hack it a bit.
    NSMutableArray *kv = [NSMutableArray array];
    for (id k in [[params allKeys] sortedArrayUsingSelector:@selector(compare:)])
        [kv addObject:[NSString stringWithFormat:@"%@=%@", k, [params objectForKey:k]]];
    [TestFlight passCheckpoint:[event stringByAppendingFormat:@"_%@", [kv componentsJoinedByString:@";"]]];
}

+ (void)endTimedEvent:(NSString *)event {
    [self endTimedEvent:event withParameters:nil];
}

+ (void)endTimedEvent:(NSString *)event withParameters:(NSDictionary *)params {
    NSLog(@"event = %@, params = %@ ended", event, params);
    [Flurry endTimedEvent:event withParameters:params];
}


@end