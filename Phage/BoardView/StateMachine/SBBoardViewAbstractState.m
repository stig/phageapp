//
// Created by SuperPappi on 20/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBBoardViewAbstractState.h"
#import "SBBoardView.h"
#import "SBBoardViewDraggedState.h"
#import "SBPieceLayer.h"

@implementation SBBoardViewAbstractState
@synthesize delegate = _delegate;
@synthesize selectedPieceLayer = _selectedPieceLayer;
@synthesize touchDownPieceLayer = _touchDownPieceLayer;


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
    [self transitionOut];
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
    state.previousState = self;
    state.draggingPieceLayer = self.touchDownPieceLayer;
    [self transitionToState:state];
    [state touchesMoved:touches];
}

- (void)touchesEnded:(NSSet *)touches {}


@end