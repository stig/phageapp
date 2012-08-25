//
//  SBHowtoViewController+.h
//  Phage
//
//  Created by Stig Brautaset on 31/07/2012.
//
//

#import <UIKit/UIKit.h>

@class SBHowtoViewController;

@protocol SBHowtoViewControllerDelegate
- (void)howtoViewControllerDidFinish:(SBHowtoViewController *)controller;
@end

@interface SBHowtoViewController : UIViewController

@property (weak, nonatomic) id <SBHowtoViewControllerDelegate> delegate;

@end
