//
// Created by SuperPappi on 07/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//



#import "SBMatchViewControllerState.h"

@class SBPiece;

@interface SBMatchViewControllerStateSelected : SBMatchViewControllerState
@property(nonatomic, weak) SBPiece* selected;

- (BOOL)isEqualToMatchViewControllerStateSelected:(SBMatchViewControllerStateSelected *)other;

@end