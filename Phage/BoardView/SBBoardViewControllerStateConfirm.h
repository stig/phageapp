//
// Created by SuperPappi on 07/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//



#import "SBBoardViewControllerState.h"

@interface SBBoardViewControllerStateConfirm : SBBoardViewControllerState
@property(nonatomic, strong) SBBoardViewControllerState *previousState;
@property(nonatomic, weak) SBPiece* selected;
@property(nonatomic, weak) SBLocation* destination;
@end