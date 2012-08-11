//
// Created by SuperPappi on 07/08/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//



@class SBMatch;
static NSString *const SUFFIX = @"match";

@interface SBMatchService : NSObject

- (NSString *)savedMatchesPath;

- (void)saveMatch:(SBMatch *)match;
- (void)deleteMatch:(SBMatch *)match;
- (NSArray*)allMatches;
- (NSArray*)activeMatches;

@end