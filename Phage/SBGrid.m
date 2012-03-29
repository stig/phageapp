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
    return [self isEqualToGrid:other];
}

- (BOOL)isEqualToGrid:(SBGrid *)other {
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

#pragma mark logic

- (BOOL)isGridColumn:(NSInteger)c row:(NSInteger)r {
    return c >= 0 && c < GRIDSIZE && r >= 0 && r < GRIDSIZE;
}

- (BOOL)isGridLocation:(SBLocation*)loc {
    return [self isGridColumn:loc.column row:loc.row];
}

- (BOOL)isUnoccupiedGridLocation:(SBLocation *)loc {
    if (![self isGridLocation:loc])
        return NO;
    return nil == [self pieceAtLocation:loc];
}

#pragma mark mutators

- (void)setPiece:(SBPiece *)piece atColumn:(NSInteger)c row:(NSInteger)r {
    NSParameterAssert([self isGridColumn:c row:r]);
    grid[c][r] = piece;
}

- (SBPiece *)pieceAtColumn:(NSInteger)c row:(NSInteger)r {
    NSParameterAssert([self isGridColumn:c row:r]);
    return grid[c][r];
}

- (void)setPiece:(SBPiece *)piece atLocation:(SBLocation *)point {
    [self setPiece:piece atColumn:point.column row:point.row];
}

- (SBPiece *)pieceAtLocation:(SBLocation *)point {
    return [self pieceAtColumn:point.column row:point.row];
}

@end
