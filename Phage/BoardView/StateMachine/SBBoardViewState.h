//
// Created by SuperPappi on 28/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//

@class SBPiece;
@class SBPieceLayer;
@class SBCellLayer;
@class SBLocation;

@protocol SBBoardViewState;

@protocol SBBoardViewStateDelegate
- (void)transitionToState:(id<SBBoardViewState>)state;
- (CGPoint)pointForTouches:(NSSet*)touches;
- (BOOL)canCurrentPlayerMovePiece:(SBPiece*)piece;
- (SBPieceLayer*)pieceLayerForPoint:(CGPoint)point;
- (SBCellLayer*)cellLayerForPoint:(CGPoint)point;
- (BOOL)canMovePiece:(SBPiece*)piece toLocation:(SBLocation*)location;
- (void)movePiece:(SBPiece*)piece toLocation:(SBLocation*)location;
- (NSArray*)allCellLayers;
- (UIView*)actionSheetView;
@end

@protocol SBBoardViewState <NSObject>
@property(weak) id<SBBoardViewStateDelegate> delegate;
+ (id)state;
- (void)transitionIn;
- (void)transitionOut;
- (void)touchesBegan:(NSSet *)touches;
- (void)touchesMoved:(NSSet *)touches;
- (void)touchesEnded:(NSSet *)touches;
@end
