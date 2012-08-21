//
//  SBMove.h
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SBLocation;

@interface SBMove : NSObject <NSCopying>

@property (strong, readonly) SBLocation *from;
@property (strong, readonly) SBLocation *to;

+ (id)moveWithFrom:(SBLocation *)from to:(SBLocation *)to;

+ (id)moveFromPropertyList:(NSArray *)plist;
- (NSArray *)toPropertyList;

// isEqual: delegates to this..
- (BOOL)isEqualToMove:(SBMove*)move;



@end
