//
// Created by SuperPappi on 20/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//



#import "SBBoardViewAbstractState.h"

@class SBBoardViewSelectedState;
@class SBCellLayer;
@class SBPieceLayer;

@interface SBBoardViewDraggedState : SBBoardViewAbstractState
@property(weak) SBPieceLayer *draggingPieceLayer;
@property(weak) SBCellLayer *previousCellLayer;
@property CGPoint draggingPieceLayerOriginalPosition;
@property(strong) SBBoardViewSelectedState *previousState;
@end