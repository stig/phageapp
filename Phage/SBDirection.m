//
//  Created by stig on 26/03/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBDirection.h"


@implementation SBDirection

@synthesize column = _column;
@synthesize row = _row;

- (id)initWithColumn:(NSInteger)c row:(NSInteger)r {
    NSParameterAssert(c > -2 && c < 2);
    NSParameterAssert(r > -2 && c < 2);
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
    return [self isEqualToDirection:other];
}

- (BOOL)isEqualToDirection:(SBDirection *)other {
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
    return [NSString stringWithFormat:@"<%d,%d>", _column, _row];
}


@end