//
// Created by SuperPappi on 20/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//



#import "SBBoardViewAbstractState.h"

@class SBBoardViewSelectedState;

@interface SBBoardViewDraggedState : SBBoardViewAbstractState
@property(strong) SBBoardViewSelectedState *previousState;
@end