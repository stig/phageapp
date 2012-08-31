//
//  SBWebViewController.m
//  Phage
//
//  Created by Stig Brautaset on 31/08/2012.
//
//

#import "SBWebViewController.h"

@interface SBWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation SBWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *path = [[NSBundle mainBundle] pathForResource:self.documentName ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}

@end
