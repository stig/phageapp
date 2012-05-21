//
// Created by SuperPappi on 20/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBBoardViewAbstractState.h"
#import "SBBoardView.h"
#import "SBBoardViewDraggedState.h"
#import "SBBoardViewSelectedState.h"

@implementation SBBoardViewAbstractState
@synthesize delegate = _delegate;

+ (id)stateWithDelegate:(SBBoardView *)delegate {
    return [[self alloc] initWithDelegate:delegate];
}

+ (id)state {
    return [[self alloc] init];
}

- (id)initWithDelegate:(SBBoardView *)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

- (void)transitionToState:(SBBoardViewAbstractState *)state {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));
    state.delegate = self.delegate;
    self.delegate.state = state;
    [state transitionIn];
}

- (void)transitionIn {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));
}

- (void)transitionOut {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));
}

- (void)touchesBegan:(NSSet *)touches {}

- (void)touchesMoved:(NSSet *)touches {
    SBBoardViewDraggedState *state = [SBBoardViewDraggedState state];
    state.previousState = (SBBoardViewSelectedState *)self.delegate.state;
    [self transitionToState:state];
    [state touchesMoved:touches];
}

- (void)touchesEnded:(NSSet *)touches {}


@end