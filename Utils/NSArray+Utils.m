//
// Created by SuperPappi on 20/08/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "NSArray+Utils.h"

@implementation NSArray (Utils)

- (NSArray *)applyBlock:(id (^)(id))block {
    NSMutableArray *res = [NSMutableArray arrayWithCapacity:self.count];
    for (id o in self) {
        [res addObject:block(o)];
    }
    return res;
}

@end