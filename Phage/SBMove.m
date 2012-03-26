//
//  SBMove.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBMove.h"
#import "SBLocation.h"

@implementation SBMove

@synthesize from = _from;
@synthesize to = _to;

- (id)initWithFrom:(SBLocation *)f to:(SBLocation *)t {
    self = [super init];
    if (self) {
        _from = f;
        _to = t;
    }
    return self;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToMove:other];
}

- (BOOL)isEqualToMove:(SBMove *)other {
    if (self == other)
        return YES;
    if (![_from isEqualToLocation:other.from])
        return NO;
    if (![_to isEqualToLocation:other.to])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    return 31u * [_from hash] + [_to hash];
}

@end
