//
//  SBPiece.h
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBPiece : NSObject <NSCopying, NSCoding>

@property (readonly) BOOL isPlayerOne;
- (id)initWithPlayerOne:(BOOL)x;
- (BOOL)isEqualToPiece:(SBPiece*)piece;
- (NSArray*)directions;
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx;
@end
