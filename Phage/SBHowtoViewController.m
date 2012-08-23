//
//  SBHowtoViewController+.m
//  Phage
//
//  Created by Stig Brautaset on 31/07/2012.
//
//

#import "SBHowtoViewController.h"

@interface SBHowtoViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SBHowtoViewController

- (void)awakeFromNib
{
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 480.0);
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	NSString *path = [[NSBundle mainBundle] pathForResource:@"HowToPlay" ofType:@"html"];
	NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	
	[self.webView loadRequest:request];

    [TestFlight passCheckpoint:@"VIEW_HOW_TO"];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    [self.delegate howtoViewControllerDidFinish:self];
}

@end
