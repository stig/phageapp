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

@synthesize piece = _piece;
@synthesize to = _to;

+ (id)moveWithPiece:(SBPiece *)piece to:(SBLocation *)location {
    return [[self alloc] initWithPiece:piece to:location];
}

- (id)initWithPiece:(SBPiece *)p to:(SBLocation *)t {
    self = [super init];
    if (self) {
        _piece = p;
        _to = t;
    }
    return self;
}

- (id)copyWithZone:(NSZone*)zone {
    return self;
}

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
    if (![_piece isEqualToPiece:other.piece])
        return NO;
    if (![_to isEqualToLocation:other.to])
        return NO;
    return YES;
}

- (NSUInteger)hash {
    return 31u * [_piece hash] + [_to hash];
}

- (NSString *)description {
    return [[_piece description] stringByAppendingFormat:@":%@", [_to description]];
}

@end
