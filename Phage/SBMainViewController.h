//
//  SBMainViewController.h
//  Phage
//
//  Created by Stig Brautaset on 31/07/2012.
//
//

#import "SBFlipsideViewController.h"

@interface SBMainViewController : UIViewController <SBFlipsideViewControllerDelegate, UIPopoverControllerDelegate>

@property (strong, nonatomic) UIPopoverController *flipsidePopoverController;

@end
