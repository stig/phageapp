//
//  SBPiece.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBPiece.h"

@implementation SBPiece

@synthesize owner = _owner;

+ (id)pieceWithOwner:(NSUInteger)owner {
    return [[self alloc] initWithOwner:owner];
}

- (id)initWithOwner:(NSUInteger)owner {
    self = [super init];
    if (self) {
        _owner = owner;
    }
    return self;
}

#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)coder {
    BOOL owner = [coder decodeBoolForKey:@"SBPlayerOne"];
    return [self initWithOwner:owner ? 0 : 1];
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeBool:_owner ? NO : YES forKey:@"SBPlayerOne"];
}


#pragma mark NSCopying

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSString *substr = [NSStringFromClass([self class]) substringWithRange:NSMakeRange(2, 1)];
    return 0 == _owner ? [substr uppercaseString] : [substr lowercaseString];
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToPiece:other];
}

- (BOOL)isEqualToPiece:(SBPiece *)other {
    if (self == other)
        return YES;
    return _owner == other.owner;
}

- (NSArray *)directions {
    return [NSArray array];
}

- (NSUInteger)hash {
    return 31u * _owner + [NSStringFromClass([self class]) hash];
}

- (CGPathRef)pathInRect:(CGRect)rect {
    [self doesNotRecognizeSelector:_cmd];
    @throw @"Cannot get here";
}


@end
