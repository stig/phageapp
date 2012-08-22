//
// Created by SuperPappi on 22/08/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


@class SBPiece;
@class SBPieceView;

@protocol SBPieceViewDelegate

- (BOOL)canSelectPieceView:(SBPieceView *)pieceView;
- (void)didSelectPieceView:(SBPieceView *)pieceView;

@end

@interface SBPieceView : UIImageView

@property (weak) id<SBPieceViewDelegate> delegate;

@property (readonly, nonatomic) SBPiece *piece;

+ (id)objectWithPiece:(SBPiece *)piece;

@end