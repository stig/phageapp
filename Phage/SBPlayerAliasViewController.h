//
//  SBChangePlayerAliasViewController.h
//  Phage
//
//  Created by Stig Brautaset on 28/08/2012.
//
//

#import <UIKit/UIKit.h>

@class SBPlayerAliasViewController;

@protocol SBPlayerAliasViewControllerDelegate
- (void)playerAliasViewController:(SBPlayerAliasViewController *)aliasViewController didChangeAlias:(NSString *)alias;
@end

@interface SBPlayerAliasViewController : UIViewController

@property (weak, nonatomic) id<SBPlayerAliasViewControllerDelegate> delegate;

@end
