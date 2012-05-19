//
// Created by SuperPappi on 18/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBCellLayer.h"
#import "SBLocation.h"


@implementation SBCellLayer {
    BOOL _blocked;
    BOOL _highlighted;
}

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
    }
    return self;
}

- (void)drawInContext:(CGContextRef)ctx {
    self.lineWidth = 7.0;
    self.strokeColor = [UIColor darkGrayColor].CGColor;

    CGRect r = CGRectInset(self.bounds, 6.0, 6.0);

    CGMutablePathRef path = CGPathCreateMutable();

    CGPathMoveToPoint(path, nil, r.origin.x, r.origin.y);
    CGPathAddLineToPoint(path, nil, r.origin.x + r.size.width, r.origin.y + r.size.width);

    CGPathMoveToPoint(path, nil, r.origin.x, r.origin.y + r.size.width);
    CGPathAddLineToPoint(path, nil, r.origin.x + r.size.height, r.origin.y);

    self.path = path;
    CGPathRelease(path);
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