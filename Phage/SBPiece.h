//
//  SBPiece.h
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SBPlayer;

@interface SBPiece : NSObject <NSCopying, NSCoding>

@property (strong, readonly) SBPlayer *player;

- (id)initWithPlayer:(SBPlayer*)owner;

- (BOOL)isEqualToPiece:(SBPiece*)piece;

- (NSArray*)directions;

@end
