//
//  SBPiece.h
//  Phage
//
//  Created by Stig Brautaset on 24/3/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBPiece : NSObject <NSCopying>
@property (readonly) NSUInteger owner;

+ (id)pieceWithOwner:(NSUInteger)owner;
- (id)initWithOwner:(NSUInteger)owner;

- (NSArray*)directions;

@end
