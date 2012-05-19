//
// Created by SuperPappi on 18/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBPieceLayer.h"
#import "SBPiece.h"
#import "SBMovesLeftLayer.h"


@implementation SBPieceLayer {
    SBMovesLeftLayer *_movesLeftLayer;

}

@synthesize piece = _piece;

+ (id)layerWithPiece:(SBPiece*)piece {
    return [[self alloc] initWithPiece:piece];
}

- (id)initWithPiece:(SBPiece *)piece {
    self = [super init];
    if (self) {
        _piece = piece;
        self.delegate = piece;
        self.name = [piece description];
    }
    return self;
}

- (SBMovesLeftLayer *)movesLeftLayer {
    return _movesLeftLayer;
}

- (void)setMovesLeftLayer:(SBMovesLeftLayer *)aMovesLeftLayer {
    if (_movesLeftLayer)
        [self replaceSublayer:_movesLeftLayer with:aMovesLeftLayer];
    else
        [self addSublayer:aMovesLeftLayer];
    _movesLeftLayer = aMovesLeftLayer;
}

@end