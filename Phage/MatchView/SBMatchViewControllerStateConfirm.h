//
// Created by SuperPappi on 07/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//



#import "SBMatchViewControllerState.h"

@interface SBMatchViewControllerStateConfirm : SBMatchViewControllerState
@property(nonatomic, strong) SBMatchViewControllerState *previousState;
@property(nonatomic, weak) SBPiece* selected;
@property(nonatomic, weak) SBLocation* destination;
@end