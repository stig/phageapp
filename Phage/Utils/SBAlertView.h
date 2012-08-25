//
// Created by SuperPappi on 05/08/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//



@interface SBAlertView : UIAlertView
- (id)initWithTitle:(NSString *)title message:(NSString *)message completion:(void (^)(SBAlertView *alertView, NSInteger buttonIndex))completion cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
@end