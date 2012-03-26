//
//  SBMove.h
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SBLocation;

@interface SBMove : NSObject

@property (readonly) SBLocation *from;
@property (readonly) SBLocation *to;

- (id)initWithFrom:(SBLocation *)f to:(SBLocation *)t;

// isEqual: delegates to this..
- (BOOL)isEqualToMove:(SBMove*)move;


@end
