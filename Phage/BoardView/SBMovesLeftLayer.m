//
// Created by SuperPappi on 18/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBMovesLeftLayer.h"


@implementation SBMovesLeftLayer


- (void)setMovesLeft:(NSUInteger)aMovesLeft {
    self.string = [NSString stringWithFormat:@"%u", aMovesLeft];
}


- (CALayer *)hitTest:(CGPoint)p {
    return nil;
}


@end