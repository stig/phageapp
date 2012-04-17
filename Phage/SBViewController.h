//
//  SBViewController.h
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TurnBasedMatchHelper.h"

@class SBState;
@class GridView;

@interface SBViewController : UIViewController <TurnBasedMatchHelperDelegate>

@property (strong) TurnBasedMatchHelper *turnBasedMatchHelper;

@property (strong) IBOutlet UIButton *moveButton;
@property (strong) IBOutlet GridView *gridView;

@property (strong) SBState *currentState;

- (IBAction)go;
- (IBAction)makeMove;

@end
