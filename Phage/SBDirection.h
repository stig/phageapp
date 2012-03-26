//
//  Created by stig on 26/03/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface SBDirection : NSObject

@property (readonly) NSInteger column;
@property (readonly) NSInteger row;

- (id)initWithColumn:(NSInteger)c row:(NSInteger)r;

@end