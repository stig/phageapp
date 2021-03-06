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
- (void)didSelectPieceViewAgain:(SBPieceView *)view;

@end

@interface SBPieceView : UIImageView

@property (assign, nonatomic) NSUInteger movesLeft;

@property (weak, nonatomic) id<SBPieceViewDelegate> delegate;

@property (readonly, nonatomic) SBPiece *piece;

+ (id)objectWithPiece:(SBPiece *)piece;

- (void)bounceWithDuration:(NSNumber *)duration;


@end