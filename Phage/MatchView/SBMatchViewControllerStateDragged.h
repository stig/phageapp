//
// Created by SuperPappi on 08/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//



#import "SBMatchViewControllerState.h"

@interface SBMatchViewControllerStateDragged : SBMatchViewControllerState
@property(nonatomic, strong) SBPiece* dragged;
@property(nonatomic, strong) SBLocation* origin;
@end