//
//  SBPlayer.h
//  Phage
//
//  Created by Stig Brautaset on 14/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBPlayer : NSObject <NSCopying, NSCoding>

@property (readonly, getter=isNorth) BOOL north;

- (id)initForNorth:(BOOL)yn;
- (BOOL)isEqualToPlayer:(SBPlayer*)other;

- (id)opponent;

@end
