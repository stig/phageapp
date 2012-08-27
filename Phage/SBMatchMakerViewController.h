//
//  SBMatchMakerViewController.h
//  Phage
//
//  Created by Stig Brautaset on 16/08/2012.
//
//

#import <UIKit/UIKit.h>

@class SBMatchMakerViewController;
@class SBMatch;

@protocol SBMatchMakerViewControllerDelegate
- (void)matchMakerViewControllerDidFinish:(SBMatchMakerViewController *)controller;
- (void)matchMakerViewController:(SBMatchMakerViewController *)controller didFindMatch:(SBMatch*)match;
@end


@interface SBMatchMakerViewController : UIViewController

@property (weak, nonatomic) id <SBMatchMakerViewControllerDelegate> delegate;

- (IBAction)startOnePlayerMatch:(id)sender;
- (IBAction)startTwoPlayerMatch:(id)sender;

@end
