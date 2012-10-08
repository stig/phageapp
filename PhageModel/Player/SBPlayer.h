//
// Created by SuperPappi on 08/10/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

@protocol SBMovePicker;

typedef enum {
    SBPlayerOutcomeNone = 0u,
    SBPlayerOutcomeWon,
    SBPlayerOutcomeTied,
    SBPlayerOutcomeLost,
    SBPlayerOutcomeQuit,
} SBPlayerOutcome;

@protocol SBPlayer <NSObject>
@property(nonatomic, readonly) NSString *alias;
@property(nonatomic, readonly, getter=isHuman) BOOL human;
@property(nonatomic, readonly) SBPlayerOutcome outcome;
@property(nonatomic, readonly) id<SBMovePicker> movePicker;

- (id)withOutcome:(SBPlayerOutcome)outcome;

@end