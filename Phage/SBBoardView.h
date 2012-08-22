//
//  SBBoardView.h
//  Phage
//
//  Created by Stig Brautaset on 21/08/2012.
//
//

#import <UIKit/UIKit.h>

@protocol SBBoardViewDelegate
@end

@class SBBoard;

@interface SBBoardView : UIView

@property (weak) IBOutlet id<SBBoardViewDelegate> delegate;

- (void)layoutBoard:(SBBoard*)board;

@end
