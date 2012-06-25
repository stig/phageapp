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
@class SBMatchViewController;

@protocol SBMatchViewControllerDelegate < NSObject >
- (void)handleTurnEventForMatch:(SBMatch *)match viewController:(SBMatchViewController *)mvc;
@end

@interface SBMatchViewController : UIViewController <SBMatchViewDelegate, SBMatchViewControllerStateDelegate>

@property(strong) id<SBMatchViewControllerDelegate> delegate;

@property(strong) SBMatchViewControllerState *state; // intentionally atomic!
@property(strong) SBMatch *match; // intentionally atomic!

@property(nonatomic, weak) IBOutlet UIBarButtonItem *forfeitButton;
@property(nonatomic, strong) IBOutlet SBMatchView *gridView;

@property(nonatomic, copy) NSString *checkPointSuffix;

- (IBAction)forfeit;

- (void)movePiece:(SBPiece *)piece toLocation:(SBLocation *)location;


@end
