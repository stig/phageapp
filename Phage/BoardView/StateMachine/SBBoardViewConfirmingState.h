//
// Created by SuperPappi on 25/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//



#import "SBBoardViewAbstractState.h"

@class SBCellLayer;

@interface SBBoardViewConfirmingState : SBBoardViewAbstractState
@property(strong) SBBoardViewAbstractState *previousState;
@property CGPoint selectedPieceLayerOriginalPosition;
@property(weak) SBCellLayer *droppedCellLayer;
@end