//
//  SBBoard.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBBoard.h"
#import "SBPoint.h"

@implementation SBBoard

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToBoard:other];
}

- (BOOL)isEqualToBoard:(SBBoard *)other {
    if (self == other)
        return YES;
    
    for (int c = 0; c < BOARDSIZE; c++) {
        for (int r = 0; r < BOARDSIZE; r++) {
            id a = [self pieceAtColumn:c row:r];
            id b = [other pieceAtColumn:c row:r];
            if (a != b && ![a isEqual:b])
                return NO;
        }
    }
    return YES;
}

- (NSUInteger)hash {
    NSUInteger hash = 0;
    for (int c = 0; c < BOARDSIZE; c++) {
        for (int r = 0; r < BOARDSIZE; r++) {
            hash *= 31u;
            hash += [grid[c][r] hash];
        }
    }
    return hash;
}

- (id)pieceAtColumn:(NSInteger)c row:(NSInteger)r {
    return grid[c][r];
}

- (id)pieceAtPoint:(SBPoint *)point {
    return [self pieceAtColumn:point.column row:point.row];
}

@end
