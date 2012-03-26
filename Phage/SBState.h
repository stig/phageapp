//
//  SBState.h
//  Phage
//
//  Created by Stig Brautaset on 25/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SBGrid;

@interface SBState : NSObject {

    @private
    NSArray *north, *south;
    NSMutableDictionary *movesLeft;
    NSMutableDictionary *location;
    SBGrid *grid;
}

@end
