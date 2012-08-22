//
// Created by SuperPappi on 23/08/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBCellView.h"
#import "SBLocation.h"

@implementation SBCellView

- (id)initWithLocation:(SBLocation *)location {
    UIImage *img = [UIImage imageNamed:@"Blocked"];
    self = [self initWithImage:nil highlightedImage:img];
    if (self) {
        self.userInteractionEnabled = YES;
        _location = location;
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


@end