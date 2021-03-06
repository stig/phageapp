//
//  SBChangePlayerAliasViewController.m
//  Phage
//
//  Created by Stig Brautaset on 28/08/2012.
//
//

#import "SBPlayerAliasViewController.h"
#import "SBAnalytics.h"

#define MAXLENGTH 25

@interface SBPlayerAliasViewController () < UITextFieldDelegate >
@property (weak, nonatomic) IBOutlet UITextField *aliasTextField;
@end

@implementation SBPlayerAliasViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.aliasTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:self.aliasKey];

    [SBAnalytics logEvent:[NSString stringWithFormat:@"SHOW_%@", self.aliasKey]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [SBAnalytics logEvent:[NSString stringWithFormat:@"CHANGE_%@", self.aliasKey]];
    [[NSUserDefaults standardUserDefaults] setObject:textField.text forKey:self.aliasKey];
    [textField resignFirstResponder];
    [self.navigationController popViewControllerAnimated:YES];
    return NO;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField.text length] > MAXLENGTH) {
        [SBAnalytics logEvent:@"ALIAS_TOO_LONG"];
        textField.text = [textField.text substringToIndex:MAXLENGTH];
        return NO;
    }
    return YES;
}


@end
