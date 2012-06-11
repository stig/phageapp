//
// Created by SuperPappi on 18/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


@class SBPiece;
@class SBMovesLeftLayer;


@interface SBPieceLayer : CAShapeLayer
@property(nonatomic,readonly) SBPiece* piece;
@property(nonatomic,strong) SBMovesLeftLayer *movesLeftLayer;
+ (id)layerWithPiece:(SBPiece *)piece;
- (id)initWithPiece:(SBPiece *)piece;

@end