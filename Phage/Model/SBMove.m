//
//  SBMove.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBMove.h"
#import "SBLocation.h"
#import "SBPiece.h"

@implementation SBMove

@synthesize to = _to;
@synthesize from = _from;

+ (id)moveWithFrom:(SBLocation*)from to:(SBLocation*)to {
    return [[self alloc] initWithFrom:from to:to];
}

- (id)initWithFrom:(SBLocation *)from to:(SBLocation *)to {
    self = [super init];
    if (self) {
        _from = from;
        _to = to;
    }
    return self;
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

#pragma mark NSCopying

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_from forKey:@"SBFrom"];
    [aCoder encodeObject:_to forKey:@"SBTo"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    return [self initWithFrom:[aDecoder decodeObjectForKey:@"SBFrom"] to:[aDecoder decodeObjectForKey:@"SBTo"]];
}

#pragma mark Hashable

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
    if (![_from isEqual:other.from])
        return NO;
    if (![_to isEqual:other.to])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    return 31u * [_from hash] + [_to hash];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@@%@", self.from, self.to];
}

@end
