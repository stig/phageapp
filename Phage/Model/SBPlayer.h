//
// Created by SuperPappi on 19/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


@protocol SBPlayer <NSObject>

@property(nonatomic, readonly) NSString *alias;
@property(nonatomic, readonly) BOOL isLocalHuman;

+ (id)playerWithAlias:(NSString *)alias;
- (id)initWithAlias:(NSString *)alias;

@end