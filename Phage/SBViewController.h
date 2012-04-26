//
//  SBViewController.h
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBGameKitTurnBasedMatchHelperInternal.h"
#import "GridView.h"

@class SBState;

@interface SBViewController : UIViewController <TurnBasedMatchHelperDelegate, GridViewDelegate>

@property (strong) TurnBasedMatchHelper *turnBasedMatchHelper;
@property (strong) IBOutlet GridView *gridView;

- (IBAction)go;

@end
