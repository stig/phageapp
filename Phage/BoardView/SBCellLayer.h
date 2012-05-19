//
// Created by SuperPappi on 18/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


@class SBLocation;

@interface SBCellLayer : CAShapeLayer
@property(readonly) SBLocation *location;
@property(nonatomic) BOOL blocked;
@property(nonatomic) BOOL highlighted;

+ (id)layerWithLocation:(SBLocation*)location;
- (id)initWithLocation:(SBLocation *)location;


@end