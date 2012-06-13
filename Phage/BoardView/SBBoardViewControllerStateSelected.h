//
// Created by SuperPappi on 07/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//



#import "SBBoardViewControllerState.h"

@class SBPiece;

@interface SBBoardViewControllerStateSelected : SBBoardViewControllerState
@property(nonatomic, weak) SBPiece* selected;

- (BOOL)isEqualToBoardViewControllerSelectedState:(SBBoardViewControllerStateSelected *)other;

@end