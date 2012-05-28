//
// Created by SuperPappi on 20/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//



#import "SBBoardViewState.h"

@class SBBoardView;
@class SBPieceLayer;
@protocol SBBoardViewDelegate;

@interface SBBoardViewAbstractState : NSObject <SBBoardViewState>
@property(weak) SBPieceLayer *selectedPieceLayer;
@property(weak) SBPieceLayer *touchDownPieceLayer;

+ (id)state;
+ (id)stateWithDelegate:(id<SBBoardViewStateDelegate>)delegate;
- (id)initWithDelegate:(id<SBBoardViewStateDelegate>)delegate;

- (Class)draggedStateClass;

@end