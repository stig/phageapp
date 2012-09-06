//
// Created by SuperPappi on 23/08/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBCellView.h"
#import "SBLocation.h"

@interface SBCellView ()

@property (strong, nonatomic) UIImageView *blockedImage;
@property (strong, nonatomic) UIImageView *availableImage;

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


@end