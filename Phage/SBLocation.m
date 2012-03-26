//
//  SBPoint.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBLocation.h"

@implementation SBLocation

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

#pragma mark NSCopying

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToLocation:other];
}

- (BOOL)isEqualToLocation:(SBLocation *)other {
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

- (NSString*)description {
    static char *letters = "abcdefgh";
    return [NSString stringWithFormat:@"%c%u", letters[_column], _row+1];
}

@end
