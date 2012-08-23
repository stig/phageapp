//
// Created by SuperPappi on 23/08/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//



@class SBLocation;
@class SBCellView;

@protocol SBCellViewDelegate

- (void)touchEndedInCellView:(SBCellView*)cellView;

@end


@interface SBCellView : UIView

@property (weak, nonatomic) id<SBCellViewDelegate> delegate;

@property (readonly, nonatomic) SBLocation *location;
@property (nonatomic) BOOL blocked;

+ (id)objectWithLocation:(SBLocation *)location;


@end