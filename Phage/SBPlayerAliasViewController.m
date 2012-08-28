//
//  SBChangePlayerAliasViewController.m
//  Phage
//
//  Created by Stig Brautaset on 28/08/2012.
//
//

#import "SBPlayerAliasViewController.h"

@interface SBPlayerAliasViewController () < UITextFieldDelegate >
@property (weak, nonatomic) IBOutlet UITextField *alias;

@end

@implementation SBPlayerAliasViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setAlias:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [textField resignFirstResponder];
    [self.delegate playerAliasViewController:self didChangeAlias:textField.text];
    return NO;
}


@end
