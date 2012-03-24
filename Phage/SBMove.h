//
//  SBMove.h
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SBPoint;

@interface SBMove : NSObject

@property (readonly) SBPoint *from;
@property (readonly) SBPoint *to;

- (id)initWithFrom:(SBPoint*)f to:(SBPoint*)t;

// isEqual: delegates to this..
- (BOOL)isEqualToMove:(SBMove*)move;


@end
