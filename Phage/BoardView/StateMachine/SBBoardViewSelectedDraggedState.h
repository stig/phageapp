//
// Created by SuperPappi on 20/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//



#import "SBBoardViewAbstractState.h"

@class SBBoardViewSelectedState;
@class SBCellLayer;
@class SBPieceLayer;

@interface SBBoardViewSelectedDraggedState : SBBoardViewAbstractState
@property(weak) SBCellLayer *previousCellLayer;
@property CGPoint selectedPieceLayerOriginalPosition;
@property(strong) SBBoardViewAbstractState *previousState;

- (void)touchesMoved:(NSSet *)touches block:(void (^)(SBCellLayer *))block;

@end