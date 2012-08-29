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

- (void)viewDidLoad {
    [super viewDidLoad];

    self.aliasTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:self.aliasKey];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:self.aliasKey];
    [textField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}


@end
