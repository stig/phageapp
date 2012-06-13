//
// Created by SuperPappi on 18/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBCellLayer.h"
#import "SBLocation.h"


@implementation SBCellLayer
@synthesize location = _location;
@synthesize blocked = _blocked;
@synthesize highlighted = _highlighted;


+ (id)layerWithLocation:(SBLocation*)location {
    return [[self alloc] initWithLocation:location];
}

- (id)initWithLocation:(SBLocation *)location {
    self = [super init];
    if (self) {
        _location = location;
        self.name = [location description];
        self.borderColor = [UIColor yellowColor].CGColor;

        self.lineWidth = 7.0;
        self.strokeColor = [UIColor darkGrayColor].CGColor;
    }
    return self;
}

- (void)setBlocked:(BOOL)blocked {
    _blocked = blocked;

    [CATransaction begin];
    [CATransaction setAnimationDuration:1.0f];
    self.strokeEnd = blocked ? 1.0 : 0.0;
    [CATransaction commit];
}

- (void)setHighlighted:(BOOL)highlighted {
    _highlighted = highlighted;
    self.borderWidth = highlighted ? 1.0 : 0.0;
}


@end