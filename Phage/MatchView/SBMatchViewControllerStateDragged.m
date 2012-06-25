//
// Created by SuperPappi on 08/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBMatchViewControllerStateDragged.h"
#import "SBMatchViewControllerStateUnselected.h"
#import "SBLocation.h"

@implementation SBMatchViewControllerStateDragged
@synthesize dragged = _dragged;
@synthesize origin = _origin;


- (void)transitionIn {
    [super transitionIn];
    [self.gridView pickUpPiece:self.dragged];
}

- (void)transitionOut {
    [super transitionOut];
    [self.gridView putDownPiece:self.dragged];
}


- (void)longPressEndedAtLocation:(SBLocation *)location {
    [self transitionOut];
    if ([self.delegate canMovePiece:self.dragged toLocation:location]) {
        [self.delegate movePiece:self.dragged toLocation:location];

    } else {
        [self.gridView movePiece:self.dragged toLocation:self.origin completionHandler:^void(NSError *error) {
        }];
        [self.delegate transitionToState:[SBMatchViewControllerStateUnselected state]];

        [[[UIAlertView alloc] initWithTitle:@"Illegal Move"
                                    message:@"Double-tap a piece to show its legal destinations."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }

}

@end