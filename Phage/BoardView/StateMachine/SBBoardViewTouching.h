//
// Created by SuperPappi on 20/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


@class SBBoardView;

@protocol SBBoardViewTouching <NSObject>

- (void)touchesBegan:(NSSet*)touches inBoardView:(SBBoardView*)boardView;
- (void)touchesMoved:(NSSet*)touches inBoardView:(SBBoardView*)boardView;
- (void)touchesEnded:(NSSet*)touches inBoardView:(SBBoardView*)boardView;

@end