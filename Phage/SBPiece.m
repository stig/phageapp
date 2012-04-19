//
//  SBPiece.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBPiece.h"
#import "SBPlayer.h"

@implementation SBPiece

@synthesize player = _player;

- (id)init {
    return [self initWithPlayer:[[SBPlayer alloc] init]];
}

- (id)initWithPlayer:(SBPlayer*)player {
    self = [super init];
    if (self) {
        _player = player;
    }
    return self;
}

#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)coder {
    SBPlayer *player = [coder decodeObjectForKey:@"SBPlayerV2"];
    return [self initWithPlayer:player];
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_player forKey:@"SBPlayerV2"];
}


#pragma mark NSCopying

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

- (NSString*)description {
    NSString *substr = [NSStringFromClass([self class]) substringWithRange:NSMakeRange(2, 1)];
    return [_player isNorth] ? [substr uppercaseString] : [substr lowercaseString];
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
    return [self.player isEqualToPlayer:other.player];
}

- (NSArray *)directions {
    return [[NSArray alloc] init];
}

- (NSUInteger)hash {
    return 31u * [_player hash] + [NSStringFromClass([self class]) hash];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx {
    layer.backgroundColor = (self.player.isNorth ? [UIColor blueColor] : [UIColor redColor]).CGColor;
}

@end
