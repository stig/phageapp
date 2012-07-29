//
//  SBDiamondPiece.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBDiamond.h"
#import "SBDirection.h"

@implementation SBDiamond

- (NSArray *)directions {
    return @[[SBDirection directionWithColumn:-1 row:0],
            [SBDirection directionWithColumn:1 row:0],
            [SBDirection directionWithColumn:0 row:-1],
            [SBDirection directionWithColumn:0 row:1]];
}

@end
