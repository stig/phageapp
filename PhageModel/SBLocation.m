//
//  SBPoint.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBLocation.h"
#import "SBDirection.h"

@implementation SBLocation

@synthesize column = _column;
@synthesize row = _row;

+ (id)locationWithColumn:(NSUInteger)column row:(NSUInteger)row {
    return [[self alloc] initWithColumn:column row:row];
}

- (id)initWithColumn:(NSUInteger)c row:(NSUInteger)r {
    self = [super init];
    if (self) {
        _column = c;
        _row = r;
    }
    return self;
}

#pragma mark SBCoding

- (NSArray *)toPropertyList {
    return @[ @(_column), @(_row) ];
}

+ (id)locationFromPropertyList:(NSArray *)plist {
    return [self locationWithColumn:[plist[0] unsignedIntegerValue] row:[plist[1] unsignedIntegerValue]];
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
    return 31u * _column + _row;
}

- (NSString*)description {
    static char *letters = "abcdefgh";
    return [NSString stringWithFormat:@"%c%u", letters[_column], _row+1];
}

- (SBLocation *)locationByMovingInDirection:(SBDirection *)direction {
    NSInteger c = self.column + direction.column;
    NSInteger r = self.row + direction.row;
    if (c < 0 || r < 0 || c >= COLUMNS || r >= ROWS)
        return nil;
    return [SBLocation locationWithColumn:(NSUInteger)c row:(NSUInteger)r];
}
@end
