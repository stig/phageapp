//
//  SBBoardView.h
//  Phage
//
//  Created by Stig Brautaset on 21/08/2012.
//
//

@class SBMove;

@protocol SBBoardViewDelegate

- (BOOL)shouldAcceptUserInput;
- (void)performMove:(SBMove*)move;

@end

@class SBBoard;

@interface SBBoardView : UIView

@property (weak) IBOutlet id<SBBoardViewDelegate> delegate;

- (void)layoutBoard:(SBBoard*)board;

@end
