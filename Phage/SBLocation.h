//
//  SBPoint.h
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SBDirection;

@interface SBLocation : NSObject <NSCopying>

@property (readonly) NSInteger column;
@property (readonly) NSInteger row;

- (id)initWithColumn:(NSInteger)c row:(NSInteger)r;

// isEqual: delegates to this..
- (BOOL)isEqualToLocation:(SBLocation *)point;

- (SBLocation *)locationByMovingInDirection:(SBDirection *)direction;

@end
