//
// Created by SuperPappi on 20/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//



typedef enum {
    SBPlayerOutcomeNone = 0u,
    SBPlayerOutcomeWon,
    SBPlayerOutcomeTied,
    SBPlayerOutcomeLost,
    SBPlayerOutcomeQuit,
} SBPlayerOutcome;


@interface SBPlayer : NSObject

@property(nonatomic, readonly) NSString *alias;
@property(nonatomic, readonly, getter=isHuman) BOOL human;
@property(nonatomic, readonly) SBPlayerOutcome outcome;

+ (id)playerWithAlias:(NSString *)alias human:(BOOL)human outcome:(SBPlayerOutcome)outcome;
- (id)initWithAlias:(NSString *)alias human:(BOOL)human outcome:(SBPlayerOutcome)outcome;

+ (id)playerWithAlias:(NSString *)alias human:(BOOL)human;
+ (id)playerWithAlias:(NSString *)alias;
+ (id)player;

+ (id)playerFromPropertyList:(NSDictionary *)dict;
- (NSDictionary *)toPropertyList;

- (id)playerWithOutcome:(SBPlayerOutcome)outcome;


@end