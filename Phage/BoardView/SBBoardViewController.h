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

@class SBPhageBoard;
@class PhageModelHelper;

@interface SBBoardViewController : UIViewController <SBTurnBasedMatchHelperDelegate, SBBoardViewDelegate, SBBoardViewControllerStateDelegate>

@property(strong) SBBoardViewControllerState *state;

@property(nonatomic, weak) IBOutlet UIBarButtonItem *forfeitButton;
@property(strong) PhageModelHelper *modelHelper;
@property(strong) SBTurnBasedMatchHelper *turnBasedMatchHelper;
@property(strong) IBOutlet SBBoardView *gridView;

- (IBAction)forfeit;

@end
