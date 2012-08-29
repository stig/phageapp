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
- (void)playerAliasViewControllerDidUpdateAlias:(SBPlayerAliasViewController *)aliasViewController;
@end

@interface SBPlayerAliasViewController : UIViewController

@property (copy, nonatomic) NSString *aliasKey;
@property (weak, nonatomic) id<SBPlayerAliasViewControllerDelegate> delegate;

@end
