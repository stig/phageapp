//
//  SBTrianglePiece.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBTrianglePiece.h"
#import "SBDirection.h"

@implementation SBTrianglePiece

- (NSArray *)directions {
    return [[NSArray alloc] initWithObjects:
            [[SBDirection alloc] initWithColumn:1 row:0],
            [[SBDirection alloc] initWithColumn:-1 row:0],
            self.owner == SBPlayerNorth
                    ? [[SBDirection alloc] initWithColumn:0 row:-1]
                    : [[SBDirection alloc] initWithColumn:0 row:1],
            nil];
}
@end
