//
// Created by SuperPappi on 25/06/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBAnimationCompletionHandler.h"

@implementation SBAnimationCompletionHandler {
@private
    void (^block)(NSError *);
}

+ (id)animationCompletionHandlerWithBlock:(void (^)(NSError* error))block {
    return [[self alloc] initWithBlock:block];
}

- (id)initWithBlock:(void (^)(NSError *))aBlock {
    self = [super init];
    if (self) {
        block = aBlock;
    }
    return self;
}

- (id)init {
    return [self initWithBlock:^(NSError *error){
        NSLog(@"%s", __PRETTY_FUNCTION__);
    }];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (flag) {
        block(nil);
    }
}


@end