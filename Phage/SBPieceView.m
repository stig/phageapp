//
// Created by SuperPappi on 22/08/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBPieceView.h"
#import "SBPiece.h"

@interface SBPieceView ()

@property (nonatomic) BOOL selected;

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

    [self toggleSelected];
}

- (void)toggleSelected {
    self.selected = !self.selected;
}

- (void)setSelected:(BOOL)selected {
    _selected = selected;
    self.backgroundColor = selected ? [UIColor redColor] : [UIColor clearColor];
}


@end