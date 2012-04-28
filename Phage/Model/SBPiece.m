//
//  SBPiece.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBPiece.h"

@implementation SBPiece

@synthesize player = _player;

- (id)init {
    return [self initWithPlayer:kSBPlayerNorth];
}

- (id)initWithPlayer:(SBPlayer)player {
    self = [super init];
    if (self) {
        _player = player;
    }
    return self;
}

#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)coder {
    SBPlayer player = [coder decodeIntegerForKey:@"SBPlayer"];
    return [self initWithPlayer:player];
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeInteger:_player forKey:@"SBPlayer"];
}


#pragma mark NSCopying

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSString *substr = [NSStringFromClass([self class]) substringWithRange:NSMakeRange(2, 1)];
    return _player == kSBPlayerNorth ? [substr uppercaseString] : [substr lowercaseString];
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
    return _player == other.player;
}

- (NSArray *)directions {
    return [[NSArray alloc] init];
}

- (NSUInteger)hash {
    return 31u * _player + [NSStringFromClass([self class]) hash];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    layer.backgroundColor = (_player == kSBPlayerNorth ? [UIColor blueColor] : [UIColor redColor]).CGColor;
}

@end
