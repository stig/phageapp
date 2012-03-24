//
//  SBBoard.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBGrid.h"
#import "SBPoint.h"

@implementation SBGrid

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    return [self isEqualToBoard:other];
}

- (BOOL)isEqualToBoard:(SBGrid *)other {
    if (self == other)
        return YES;
    
    for (int c = 0; c < GRIDSIZE; c++) {
        for (int r = 0; r < GRIDSIZE; r++) {
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
    for (int c = 0; c < GRIDSIZE; c++) {
        for (int r = 0; r < GRIDSIZE; r++) {
            hash *= 31u;
            hash += [grid[c][r] hash];
        }
    }
    return hash;
}

#pragma mark mutators

- (void)setPiece:(SBPiece *)piece atColumn:(NSInteger)c row:(NSInteger)r {
    grid[c][r] = piece;
}

- (void)setPiece:(SBPiece *)piece atPoint:(SBPoint*)point {
    [self setPiece:piece atColumn:point.column row:point.row];
}

- (SBPiece *)pieceAtColumn:(NSInteger)c row:(NSInteger)r {
    return grid[c][r];
}

- (SBPiece *)pieceAtPoint:(SBPoint *)point {
    return [self pieceAtColumn:point.column row:point.row];
}

@end
