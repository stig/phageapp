//
// Created by SuperPappi on 19/06/2012.
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


@protocol SBPlayer <NSObject>

@property(nonatomic) SBPlayerOutcome outcome;
@property(nonatomic, readonly) NSString *alias;
@property(nonatomic, readonly) BOOL isLocalHuman;

+ (id)playerWithAlias:(NSString *)alias;
- (id)initWithAlias:(NSString *)alias;

@end