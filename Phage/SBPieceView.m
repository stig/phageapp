//
// Created by SuperPappi on 22/08/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBPieceView.h"

@interface SBPieceView ()

@property (nonatomic) BOOL selected;

@end

@implementation SBPieceView

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