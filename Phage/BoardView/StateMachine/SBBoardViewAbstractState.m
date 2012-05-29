//
// Created by SuperPappi on 20/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBBoardViewAbstractState.h"
#import "SBBoardViewSelectedDraggedState.h"
#import "SBPieceLayer.h"

@implementation SBBoardViewAbstractState
@synthesize delegate = _delegate;
@synthesize selectedPieceLayer = _selectedPieceLayer;
@synthesize touchDownPieceLayer = _touchDownPieceLayer;


+ (id)stateWithDelegate:(id<SBBoardViewStateDelegate>)delegate {
    return [[self alloc] initWithDelegate:delegate];
}

+ (id)state {
    return [[self alloc] init];
}

- (id)initWithDelegate:(id<SBBoardViewStateDelegate>)delegate {
    self = [super init];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

- (void)transitionIn {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));
}

- (void)transitionOut {
    NSLog(@"[%@ %s]", [self class], sel_getName(_cmd));
}

- (Class)draggedStateClass {
    return [SBBoardViewSelectedDraggedState class];
}


- (void)touchesBegan:(NSSet *)touches {}

- (void)touchesMoved:(NSSet *)touches {
    SBBoardViewSelectedDraggedState *state = [[self draggedStateClass] state];
    state.previousState = self;
    state.selectedPieceLayer = self.touchDownPieceLayer;
    [self.delegate transitionToState:state];
    [state touchesMoved:touches];
}

- (void)touchesEnded:(NSSet *)touches {}


@end