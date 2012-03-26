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
@class SBLocation;

@interface SBState : NSObject {

    @private
    NSMutableDictionary *movesLeft;
    NSMutableDictionary *location;
    SBGrid *grid;
}

@property (readonly) NSArray *north;
@property (readonly) NSArray *south;

- (NSUInteger)movesLeftForPiece:(SBPiece*)piece;
- (SBLocation *)locationForPiece:(SBPiece*)piece;

@end
