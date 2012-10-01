//
// Created by SuperPappi on 23/08/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBCellView.h"
#import "SBLocation.h"
#import "SBPieceView.h"

@interface SBCellView ()

@property (strong, nonatomic) UIImageView *blockedImage;
@property (strong, nonatomic) UIImageView *availableImage;
@property (strong, nonatomic) CALayer *maskLayer;
@property (strong, nonatomic) CALayer *outlineLayer;

@end


@implementation SBCellView

- (id)initWithLocation:(SBLocation *)location {
    UIImage *blocked = [UIImage imageNamed:@"cell-blocked.png"];
    CGRect frame = CGRectMake(0, 0, blocked.size.width, blocked.size.height);

    self = [super initWithFrame:frame];
    if (self) {
        _location = location;
        self.blockedImage = [[UIImageView alloc] initWithImage:blocked];

        // Set this to avoid blocked image showing up on first load of the board
        self.blockedImage.alpha = 0.0;


        UIImage *available = [UIImage imageNamed:@"cell-available.png"];
        if (available) {
            self.availableImage = [[UIImageView alloc] initWithImage:available];
            [self addSubview:self.availableImage];
        }

        [self addSubview:self.blockedImage];

        CALayer *mask = [CALayer layer];
        mask.frame = CGRectInset(self.bounds, 10, 10);
        self.maskLayer = mask;

        CALayer *outline = [CALayer layer];
        outline.mask = self.maskLayer;
        outline.frame = self.bounds;
        self.outlineLayer = outline;

        [self.layer addSublayer:outline];
    }
    return self;
}

+ (id)objectWithLocation:(SBLocation *)location {
    return [[SBCellView alloc] initWithLocation:location];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];

    [self.delegate touchEndedInCellView:self];
}

- (void)setBlocked:(BOOL)blocked {
    _blocked = blocked;

    [UIView animateWithDuration:ANIM_DURATION animations:^{
        self.blockedImage.alpha = blocked ? 1.0 : 0.0;
        self.availableImage.alpha = blocked ? 0.0 : 1.0;
    }];
}

- (void)showAsValidDestinationForPiece:(SBPieceView *)pieceView {
    if (pieceView) {
        self.maskLayer.contents = (id) pieceView.image.CGImage;
        self.outlineLayer.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.3].CGColor;

    } else {
        self.outlineLayer.backgroundColor = [UIColor clearColor].CGColor;
    }
}



@end