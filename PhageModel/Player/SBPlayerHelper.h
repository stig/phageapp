//
// Created by SuperPappi on 08/10/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


static NSString *const DEFAULT_BOT = @"DEFAULT_BOT";

@protocol SBPlayer;

@interface SBPlayerHelper : NSObject

+ (id)helper;

- (id<SBPlayer>)humanWithAlias:(NSString *)alias;

- (void)setDefaultBot:(id<SBPlayer>)bot;
- (id<SBPlayer>)defaultBot;

- (id<SBPlayer>)pepperBot;

- (NSArray *)bots;

- (NSDictionary *)toPropertyList:(id <SBPlayer>)player;
- (id<SBPlayer>)fromPropertyList:(NSDictionary *)prop;

@end