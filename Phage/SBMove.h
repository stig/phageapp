//
//  SBMove.h
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SBLocation;
@class SBPiece;

@interface SBMove : NSObject

@property (readonly) SBPiece *piece;
@property (readonly) SBLocation *to;

- (id)initWithPiece:(SBPiece *)piece to:(SBLocation *)location;

// isEqual: delegates to this..
- (BOOL)isEqualToMove:(SBMove*)move;


@end
