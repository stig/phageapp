//
// Created by SuperPappi on 18/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBPieceLayer.h"
#import "SBPiece.h"


@implementation SBPieceLayer

@synthesize piece = _piece;
@synthesize movesLeftLayer = _movesLeftLayer;


+ (id)layerWithPiece:(SBPiece*)piece {
    return [[self alloc] initWithPiece:piece];
}

- (id)initWithPiece:(SBPiece *)piece {
    self = [super init];
    if (self) {
        _piece = piece;
        self.name = [piece description];

        self.fillColor = [UIColor colorWithWhite:0.5 alpha:0.5].CGColor;
        self.lineWidth = 7.0;
        self.strokeColor = (piece.isPlayerOne == YES ? [UIColor blueColor] : [UIColor redColor]).CGColor;
    }
    return self;
}

@end