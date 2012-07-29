//
//  SBSquarePiece.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBSquare.h"
#import "SBDirection.h"

@implementation SBSquare

- (NSArray *)directions {
    return @[[SBDirection directionWithColumn:-1 row:-1],
            [SBDirection directionWithColumn:1 row:-1],
            [SBDirection directionWithColumn:-1 row:1],
            [SBDirection directionWithColumn:1 row:1]];
}


@end
