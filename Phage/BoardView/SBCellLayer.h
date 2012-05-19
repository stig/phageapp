//
// Created by SuperPappi on 18/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


@class SBLocation;

@interface SBCellLayer : CAShapeLayer
@property(readonly) SBLocation *location;

+ (id)layerWithLocation:(SBLocation*)location;
- (id)initWithLocation:(SBLocation *)location;

- (void)setBlocked:(BOOL)blocked;

@end