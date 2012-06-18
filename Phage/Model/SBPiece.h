//
//  SBPiece.h
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBPiece : NSObject <NSCopying, NSCoding>
@property (readonly) NSUInteger owner;

+ (id)pieceWithOwner:(NSUInteger)owner;

- (id)initWithOwner:(NSUInteger)owner;

- (BOOL)isEqualToPiece:(SBPiece*)piece;
- (NSArray*)directions;
- (CGPathRef)pathInRect:(CGRect)rect;
@end
