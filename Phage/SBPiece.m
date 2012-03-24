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
    return [self initWithOwner:NORTH];
}

- (id)initWithOwner:(SBPlayer)owner {
    self = [super init];
    if (self) {
        _owner = owner;
    }
    return self;
}

- (NSString*)shortDescription {
    NSString *substr = [NSStringFromClass([self class]) substringWithRange:NSMakeRange(2, 1)];
    return _owner == NORTH ? [substr uppercaseString] : [substr lowercaseString];
}

@end
