//
//  SBMatchLookupViewController.h
//  Phage
//
//  Created by Stig Brautaset on 16/08/2012.
//
//

#import <UIKit/UIKit.h>

@class SBMatchLookupViewController;
@class SBMatch;

@protocol SBMatchLookupViewControllerDelegate
- (void)matchLookupViewControllerDidFinish:(SBMatchLookupViewController *)controller;
- (void)matchLookupViewController:(SBMatchLookupViewController *)controller didFindMatch:(SBMatch*)match;
@end


@interface SBMatchLookupViewController : UITableViewController

@property (weak, nonatomic) id <SBMatchLookupViewControllerDelegate> delegate;

@end
