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


@interface SBPlayer : NSObject < NSCoding >

@property(nonatomic) SBPlayerOutcome outcome;
@property(nonatomic) NSString *alias;
@property(nonatomic, getter=isLocalHuman) BOOL localHuman;

+ (id)player;
+ (id)playerWithAlias:(NSString *)alias;

@end