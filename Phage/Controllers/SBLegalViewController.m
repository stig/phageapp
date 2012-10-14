//
// Created by SuperPappi on 09/10/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBLegalViewController.h"
#import "SBAnalytics.h"

@implementation SBLegalViewController

- (void)viewDidLoad {
    self.documentName = @"Legal.html";
    [SBAnalytics logEvent:@"SHOW_LEGAL"];
}

@end