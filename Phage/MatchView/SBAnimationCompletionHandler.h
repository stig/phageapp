//
// Created by SuperPappi on 25/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//



@interface SBAnimationCompletionHandler : NSObject
+ (id)animationCompletionHandlerWithBlock:(void (^)(NSError *))block;
@end