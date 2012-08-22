//
// Created by SuperPappi on 22/08/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


@class SBPiece;

@protocol SBPieceViewDelegate

- (BOOL)canSelectPiece:(SBPiece*)piece;

@end

@interface SBPieceView : UIImageView

@property (weak) id<SBPieceViewDelegate> delegate;

@property (readonly, nonatomic) SBPiece *piece;

+ (id)objectWithPiece:(SBPiece *)piece;

@end