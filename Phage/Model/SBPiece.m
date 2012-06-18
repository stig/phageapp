//
//  SBPiece.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBPiece.h"

@implementation SBPiece

@synthesize isPlayerOne = _isPlayerOne;

- (id)init {
    return [self initWithPlayerOne:YES];
}

- (id)initWithPlayerOne:(BOOL)owner {
    self = [super init];
    if (self) {
        _isPlayerOne = owner;
    }
    return self;
}

#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)coder {
    return [self initWithPlayerOne:[coder decodeBoolForKey:@"SBPlayerOne"]];
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeBool:_isPlayerOne forKey:@"SBPlayerOne"];
}


#pragma mark NSCopying

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSString *substr = [NSStringFromClass([self class]) substringWithRange:NSMakeRange(2, 1)];
    return _isPlayerOne == YES ? [substr uppercaseString] : [substr lowercaseString];
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
    return _isPlayerOne == other.isPlayerOne;
}

- (NSArray *)directions {
    return [[NSArray alloc] init];
}

- (NSUInteger)hash {
    return 31u * _isPlayerOne + [NSStringFromClass([self class]) hash];
}

- (CGPathRef)pathInRect:(CGRect)rect {
    [self doesNotRecognizeSelector:_cmd];
    @throw @"Cannot get here";
}


@end
