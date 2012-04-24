//
//  SBPlayer.m
//  Phage
//
//  Created by Stig Brautaset on 14/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBPlayer.h"

@implementation SBPlayer

@synthesize north = _north;

- (id)init {
    return [self initForNorth:YES];
}

- (id)initForNorth:(BOOL)yn {
    self = [super init];
    if (self) {
        _north = yn;
    }
    return self;
}

- (id)opponent {
    return [[[self class] alloc] initForNorth:!_north];
}

#pragma mark Hashing

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToPlayer:other];
}

- (BOOL)isEqualToPlayer:(SBPlayer *)other {
    return self == other || self.isNorth == other.isNorth;
}

- (NSUInteger)hash {
    return _north;
}

#pragma mark NSCopying

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

#pragma mark NSCoding

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeBool:_north forKey:@"SBNorth"];
}

- (id)initWithCoder:(NSCoder *)coder {
    return [self initForNorth:[coder decodeBoolForKey:@"SBNorth"]];
}

#pragma mark -

- (NSString*)description {
    return [NSString stringWithFormat:@"%@", self.isNorth ? @"NORTH" : @"SOUTH"];
}

@end
