//
// Created by SuperPappi on 05/08/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBAlertView.h"

@interface SBAlertView () < UIAlertViewDelegate >
@property (copy, nonatomic) void (^completion)(NSInteger);
@end

@implementation SBAlertView

- (id)initWithTitle:(NSString *)title message:(NSString *)message completion:(void (^)(NSInteger buttonIndex))theCompletion cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... {
    self.completion = theCompletion;
    return [super initWithTitle:title message:message delegate:self
              cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles, nil];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (self.completion)
        self.completion(buttonIndex);
}

@end