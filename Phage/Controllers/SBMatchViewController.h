//
//  SBMatchViewController.h
//  Phage
//
//  Created by Stig Brautaset on 31/07/2012.
//
//

@class SBMatch;
@class SBMatchViewController;

@protocol SBMatchViewControllerDelegate
- (void)matchViewController:(SBMatchViewController*)matchViewController didChangeMatch:(SBMatch *)match;
- (void)matchViewController:(SBMatchViewController*)matchViewController didDeleteMatch:(SBMatch *)match;
@end


@interface SBMatchViewController : UIViewController
@property (weak, nonatomic) IBOutlet id<SBMatchViewControllerDelegate> delegate;
@property (weak, nonatomic) SBMatch *match;
@end
