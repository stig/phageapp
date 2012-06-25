//
// Created by SuperPappi on 07/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBMatchViewControllerStateConfirm.h"
#import "SBMatchViewControllerStateUnselected.h"

static NSString *const kSBPhageConfirmKey = @"SBPhageConfirmKey";

@interface SBMatchViewControllerStateConfirm () < UIActionSheetDelegate >
@end

@implementation SBMatchViewControllerStateConfirm
@synthesize selected = _selected;
@synthesize destination = _destination;
@synthesize previousState = _previousState;


- (void)transitionIn {
    [super transitionIn];

    [self.gridView movePiece:self.selected toLocation:self.destination completionHandler:^void(NSError *error) {
    }];

    if (![[NSUserDefaults standardUserDefaults] boolForKey:kSBPhageConfirmKey]) {
        UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"Perform this move?"
                                                        delegate:self
                                               cancelButtonTitle:@"No"
                                          destructiveButtonTitle:@"Yes; don't ask again"
                                               otherButtonTitles:@"Yes", nil];
        [as showInView:self.gridView];
    } else {
        [self.previousState transitionOut];
        [self.delegate movePiece:self.selected toLocation:self.destination];
    }
}

- (void)transitionOut {
    [self.gridView movePiece:self.selected toLocation:[self.delegate locationOfPiece:self.selected] completionHandler:^void(NSError *error) {
    }];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.previousState transitionOut];

    if (actionSheet.cancelButtonIndex == buttonIndex) {
        [self transitionOut];
        [self.delegate transitionToState:[SBMatchViewControllerStateUnselected state]];

    } else {
        [self.delegate movePiece:self.selected toLocation:self.destination];
        if (actionSheet.destructiveButtonIndex ==  buttonIndex) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setBool:YES forKey:kSBPhageConfirmKey];
            [defaults synchronize];
        }
    }
}


@end