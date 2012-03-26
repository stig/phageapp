//
//  SBPiece.h
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum { NORTH, SOUTH } SBPlayer;

@interface SBPiece : NSObject <NSCopying>

@property (readonly) SBPlayer owner;

- (id)initWithOwner:(SBPlayer)owner;

- (BOOL)isEqualToPiece:(SBPiece*)piece;

@end
