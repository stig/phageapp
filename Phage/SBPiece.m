//
//  SBPiece.m
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SBPiece.h"

@implementation SBPiece

@synthesize owner = _owner;

- (id)init {
    return [self initWithOwner:@"Unknown"];
}

- (id)initWithOwner:(id)owner {
    self = [super init];
    if (self) {
        _owner = owner;
    }
    return self;
}

@end
