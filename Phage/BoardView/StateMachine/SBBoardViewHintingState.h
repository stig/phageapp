//
// Created by SuperPappi on 21/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//



#import "SBBoardViewAbstractState.h"

@class SBPieceLayer;

@interface SBBoardViewHintingState : SBBoardViewAbstractState
@property(weak) SBPieceLayer *selectedPieceLayer;
@end