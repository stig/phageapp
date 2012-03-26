//
//  SBBoard.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBGrid.h"
#import "SBLocation.h"
#import "SBPiece.h"

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

- (NSString*)description {
    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:GRIDSIZE * GRIDSIZE + GRIDSIZE];
    for (int r = GRIDSIZE - 1; r >= 0; r--) {
        for (int c = 0; c < GRIDSIZE; c++) {
            id a = [self pieceAtColumn:c row:r];
            [string appendFormat:@"%@", a == nil ? @"." : a];
        }
        [string appendString:@"\n"];
    }
    return string;
}

#pragma mark mutators

- (void)setPiece:(SBPiece *)piece atColumn:(NSInteger)c row:(NSInteger)r {
    NSParameterAssert(c >= 0 && c < GRIDSIZE);
    NSParameterAssert(r >= 0 && r < GRIDSIZE);
    grid[r][c] = piece;
}

- (SBPiece *)pieceAtColumn:(NSInteger)c row:(NSInteger)r {
    NSParameterAssert(c >= 0 && c < GRIDSIZE);
    NSParameterAssert(r >= 0 && r < GRIDSIZE);
    return grid[r][c];
}

- (void)setPiece:(SBPiece *)piece atLocation:(SBLocation *)point {
    [self setPiece:piece atColumn:point.column row:point.row];
}

- (SBPiece *)pieceAtLocation:(SBLocation *)point {
    return [self pieceAtColumn:point.column row:point.row];
}

@end
