//
//  SBViewController.h
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBMatchView.h"
#import "SBMatchViewControllerState.h"

@class SBMatch;

@interface SBMatchViewController : UIViewController <SBMatchViewDelegate, SBMatchViewControllerStateDelegate>

@property(strong) SBMatchViewControllerState *state; // intentionally atomic!
@property(strong) SBMatch *match; // intentionally atomic!

@property(nonatomic, weak) IBOutlet UIBarButtonItem *forfeitButton;
@property(nonatomic, strong) IBOutlet SBMatchView *gridView;

@property(nonatomic, copy) NSString *checkPointBaseName;

- (IBAction)forfeit;

@end
