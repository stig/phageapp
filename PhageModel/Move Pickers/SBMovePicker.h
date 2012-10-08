//
// Created by SuperPappi on 08/10/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


@class SBMove;
@class SBBoard;

@protocol SBMovePicker
- (SBMove *)moveForState:(SBBoard *)state;
@end