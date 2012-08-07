//
//  SBPoint.h
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SBBoardDimensions) {
    ROWS = 8u,
    COLUMNS = 8u,
};

@class SBDirection;

@interface SBLocation : NSObject <NSCopying, NSCoding>

@property (readonly) NSUInteger column;
@property (readonly) NSUInteger row;

+ (id)locationWithColumn:(NSUInteger)column row:(NSUInteger)row;
- (id)initWithColumn:(NSUInteger)c row:(NSUInteger)r;

// isEqual: delegates to this..
- (BOOL)isEqualToLocation:(SBLocation *)point;

- (SBLocation *)locationByMovingInDirection:(SBDirection *)direction;

@end
