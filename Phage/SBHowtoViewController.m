//
// Created by SuperPappi on 09/10/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBHowtoViewController.h"
#import "SBAnalytics.h"

@implementation SBHowtoViewController

- (void)viewDidLoad {
    self.documentName = @"HowToPlay.html";
    [SBAnalytics logEvent:@"SHOW_HOWTO"];
}

@end