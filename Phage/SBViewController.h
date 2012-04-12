//
//  SBViewController.h
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

@class SBState;

@interface SBViewController : UIViewController <GKTurnBasedMatchmakerViewControllerDelegate>

@property (strong) IBOutlet UIButton *moveButton;
@property (strong) IBOutlet UITextView *textView;

@property (strong) GKTurnBasedMatch *currentMatch;
@property (strong) SBState *currentState;

- (IBAction)go;
- (IBAction)makeMove;

@end
