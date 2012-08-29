//
//  SBChangePlayerAliasViewController.m
//  Phage
//
//  Created by Stig Brautaset on 28/08/2012.
//
//

#import "SBPlayerAliasViewController.h"

@interface SBPlayerAliasViewController () < UITextFieldDelegate >
@property (weak, nonatomic) IBOutlet UITextField *aliasTextField;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.aliasTextField.text = self.alias;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self.alias = textField.text;
    [textField resignFirstResponder];
    [self.delegate playerAliasViewController:self didChangeAlias:textField.text];
    return NO;
}


@end
