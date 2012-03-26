//
//  SBState.h
//  Phage
//
//  Created by Stig Brautaset on 25/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SBGrid;
@class SBPiece;
@class SBPoint;

@interface SBState : NSObject {

    @private
    NSMutableDictionary *movesLeft;
    NSMutableDictionary *location;
    SBGrid *grid;
}

@property (readonly) NSArray *north;
@property (readonly) NSArray *south;

- (NSUInteger)movesLeft:(SBPiece*)piece;

@end
