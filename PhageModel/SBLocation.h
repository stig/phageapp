//
//  SBPoint.h
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ROWS = 8u,
    COLUMNS = 8u,
} SBBoardDimensions;

@class SBDirection;

@interface SBLocation : NSObject <NSCopying>

@property (readonly) NSUInteger column;
@property (readonly) NSUInteger row;

+ (id)locationWithColumn:(NSUInteger)column row:(NSUInteger)row;

+ (id)locationFromPropertyList:(NSArray *)plist;
- (NSArray *)toPropertyList;

// isEqual: delegates to this..
- (BOOL)isEqualToLocation:(SBLocation *)point;

- (SBLocation *)locationByMovingInDirection:(SBDirection *)direction;

@end
