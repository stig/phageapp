//
//  SBCreateMatchViewController.h
//  Phage
//
//  Created by Stig Brautaset on 16/08/2012.
//
//

#import <UIKit/UIKit.h>

@class SBCreateMatchViewController;
@class SBMatch;

@protocol SBCreateMatchViewControllerDelegate
- (void)createMatchViewControllerDidFinish:(SBCreateMatchViewController *)controller;
- (void)createMatchViewController:(SBCreateMatchViewController *)controller didCreateMatch:(SBMatch*)match;
@end


@interface SBCreateMatchViewController : UIViewController

@property (weak, nonatomic) id <SBCreateMatchViewControllerDelegate> delegate;

- (IBAction)startOnePlayerMatch:(id)sender;
- (IBAction)startTwoPlayerMatch:(id)sender;

@end
