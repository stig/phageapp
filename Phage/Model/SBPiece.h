//
//  SBPiece.h
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kSBPlayerNorth = 0,
    kSBPlayerSouth = 1,
} SBPlayer;

@interface SBPiece : NSObject <NSCopying, NSCoding>

@property (readonly) SBPlayer player;
- (id)initWithPlayer:(SBPlayer)owner;
- (BOOL)isEqualToPiece:(SBPiece*)piece;
- (NSArray*)directions;
- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx;
@end
