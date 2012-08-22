//
// Created by SuperPappi on 22/08/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//



@class SBPiece;

@interface SBPieceView : UIImageView

@property (readonly, nonatomic) SBPiece *piece;

+ (id)objectWithPiece:(SBPiece *)piece;

@end