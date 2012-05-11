//
//  SBViewController.h
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GridView.h"
#import "SBTurnBasedMatchHelper.h"

@class SBState;
@class PhageModelHelper;

@interface SBViewController : UIViewController <SBTurnBasedMatchHelperDelegate, GridViewDelegate>

@property(strong) PhageModelHelper *modelHelper;
@property(strong) SBTurnBasedMatchHelper *turnBasedMatchHelper;
@property(strong) IBOutlet GridView *gridView;

- (IBAction)go;

@end
