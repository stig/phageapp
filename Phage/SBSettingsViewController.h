//
//  SBSettingsViewController.h
//  Phage
//
//  Created by Stig Brautaset on 25/08/2012.
//
//

#import <UIKit/UIKit.h>

@class SBSettingsViewController;

@protocol SBSettingsViewControllerDelegate
- (void)settingsViewControllerDidFinish:(SBSettingsViewController *)controller;
@end


@interface SBSettingsViewController : UIViewController
@property (weak, nonatomic) id <SBSettingsViewControllerDelegate> delegate;
@end
