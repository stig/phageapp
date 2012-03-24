//
//  SBPoint.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBPoint.h"

@implementation SBPoint

@synthesize column = _column;
@synthesize row = _row;

- (id)initWithColumn:(NSInteger)c row:(NSInteger)r {
    self = [super init];
    if (self) {
        _column = c;
        _row = r;
    }
    return self;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToPoint:other];
}

- (BOOL)isEqualToPoint:(SBPoint *)other {
    if (self == other)
        return YES;
    if (_column != other.column)
        return NO;
    if (_row != other.row)
        return NO;
    return YES;
}

- (NSUInteger)hash {
    return 31u * (NSUInteger)_column + (NSUInteger)_row;
}

@end
