//
// Created by SuperPappi on 20/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//



@class SBBoardView;

@interface SBBoardViewAbstractState : NSObject
@property(weak) SBBoardView *delegate;

+ (id)state;
+ (id)stateWithDelegate:(SBBoardView *)delegate;
- (id)initWithDelegate:(SBBoardView *)delegate;

- (void)transitionToState:(SBBoardViewAbstractState *)state;


// Overriden in subclasses to handle specifics of each state
- (void)transitionIn;
- (void)transitionOut;
- (void)touchesBegan:(NSSet *)touches;
- (void)touchesMoved:(NSSet *)touches;
- (void)touchesEnded:(NSSet *)touches;

@end