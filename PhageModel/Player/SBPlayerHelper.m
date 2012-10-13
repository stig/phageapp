//
// Created by SuperPappi on 08/10/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBPlayerHelper.h"
#import "SBHuman.h"
#import "SBPepperBot.h"
#import "SBPartsBot.h"
#import "SBColeslawBot.h"


static NSString *const ALIAS = @"a";
static NSString *const HUMAN = @"h";
static NSString *const OUTCOME = @"o";
static NSString *const CLASS = @"c";

@implementation SBPlayerHelper

+ (id)helper {
    return [[self alloc] init];
}

- (id <SBPlayer>)humanWithAlias:(NSString *)alias {
    return [SBHuman humanWithAlias:alias];
}

- (void)setDefaultBot:(id <SBPlayer>)bot {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self toPropertyList:bot] forKey:DEFAULT_BOT];
    [defaults synchronize];
}

- (id <SBPlayer>)defaultBot {
    return [self fromPropertyList:[[NSUserDefaults standardUserDefaults] objectForKey:DEFAULT_BOT]];
}

- (id <SBPlayer>)pepperBot {
    return [SBPepperBot bot];
}

- (NSArray *)bots {
    return @[
        [SBPartsBot bot],
        [self pepperBot],
        [SBColeslawBot bot]
    ];
}

- (NSDictionary *)toPropertyList:(id<SBPlayer>)player {
    return @{
        @"v": @2,
        ALIAS: player.alias,
        OUTCOME: @(player.outcome),
        CLASS: NSStringFromClass(player.class)
    };
}

- (id <SBPlayer>)fromPropertyList:(NSDictionary *)dict {
    NSNumber *version = dict[@"v"];

    id<SBPlayer> player = nil;
    if ([version isEqualToNumber:@1]) {
        if ([dict[HUMAN] boolValue])
            player = [self humanWithAlias:dict[ALIAS]];
        else
            player = [self pepperBot];

    } else if ([version isEqualToNumber:@2]) {
        Class clazz = NSClassFromString(dict[CLASS]);
        if (clazz == [SBHuman class])
            player = [clazz humanWithAlias:dict[ALIAS]];
        else
            player = [NSClassFromString(dict[CLASS]) bot];

    } else {
        @throw @"Unsupported version; please upgrade Phage!";
    }

    // Now ensure we get the outcome right.
    return [player withOutcome:(SBPlayerOutcome) [dict[OUTCOME] integerValue]];
}




@end