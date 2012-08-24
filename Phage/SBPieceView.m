//
// Created by SuperPappi on 22/08/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBPieceView.h"
#import "SBPiece.h"

@interface SBPieceView ()
@property (weak, nonatomic) CATextLayer *movesLeftLayer;
@end

@implementation SBPieceView

- (id)initWithPiece:(SBPiece *)piece {
    NSParameterAssert(piece);

    NSString *prefix = piece.owner == 0 ? @"South" : @"North";
    NSString *suffix = [NSStringFromClass([piece class]) substringFromIndex:2];
    UIImage *img = [UIImage imageNamed:[prefix stringByAppendingString:suffix]];

    self = [self initWithImage:img];
    if (self) {
        _piece = piece;

        CGRect offsetRect = CGRectOffset(self.bounds, self.bounds.size.width / 1.67, -self.bounds.size.height / 1.67);

        CATextLayer *mll= [CATextLayer layer];
        mll.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.7].CGColor;
        mll.frame = CGRectIntersection(self.bounds, offsetRect);
        mll.cornerRadius = mll.frame.size.height / 2.0;
        mll.fontSize = (CGFloat)floor(mll.frame.size.height);

        self.movesLeftLayer = mll;
        [self.layer addSublayer:self.movesLeftLayer];
    }
    return self;
}

+ (id)objectWithPiece:(SBPiece *)piece {
    return [[SBPieceView alloc] initWithPiece:piece];
}


- (id)initWithImage:(UIImage *)image {
    self = [super initWithImage:image];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];

    if ([self.delegate canSelectPieceView:self]) {
        [self.delegate didSelectPieceView:self];
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    self.backgroundColor = highlighted ? [UIColor redColor] : [UIColor clearColor];
}


- (void)setMovesLeft:(NSUInteger)movesLeft {
    self.movesLeftLayer.string = [NSString stringWithFormat:@"%u", movesLeft];
}

@end