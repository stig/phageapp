//
//  SBTrianglePiece.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBTriangle.h"
#import "SBDirection.h"

@implementation SBTriangle

- (NSArray *)directions {
    return @[[SBDirection directionWithColumn:1 row:0],
            [SBDirection directionWithColumn:-1 row:0],
            self.owner == 0
                    ? [SBDirection directionWithColumn:0 row:-1]
                    : [SBDirection directionWithColumn:0 row:1]];
}


@end
