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
- (void)createMatchViewController:(SBCreateMatchViewController *)controller didCreateMatch:(SBMatch*)match;
@end


@interface SBCreateMatchViewController : UITableViewController

@property (weak, nonatomic) id <SBCreateMatchViewControllerDelegate> delegate;

@end
