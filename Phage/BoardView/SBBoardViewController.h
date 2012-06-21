//
//  SBViewController.h
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBBoardView.h"
#import "SBTurnBasedMatchHelper.h"
#import "SBBoardViewControllerState.h"

@class SBPhageMatch;

@interface SBBoardViewController : UIViewController <SBBoardViewDelegate, SBBoardViewControllerStateDelegate>

@property(strong) SBBoardViewControllerState *state; // intentionally atomic!
@property(strong) SBPhageMatch *phageMatch; // intentionally atomic!

@property(nonatomic, weak) IBOutlet UIBarButtonItem *forfeitButton;
@property(nonatomic, strong) IBOutlet SBBoardView *gridView;

- (IBAction)forfeit;

@end
