//
//  SBFlipsideViewController.h
//  Phage
//
//  Created by Stig Brautaset on 31/07/2012.
//
//

#import <UIKit/UIKit.h>

@class SBFlipsideViewController;

@protocol SBFlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(SBFlipsideViewController *)controller;
@end

@interface SBFlipsideViewController : UIViewController

@property (weak, nonatomic) id <SBFlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
