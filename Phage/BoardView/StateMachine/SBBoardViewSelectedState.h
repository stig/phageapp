//
// Created by SuperPappi on 20/05/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//



#import "SBBoardViewAbstractState.h"

@interface SBBoardViewSelectedState : SBBoardViewAbstractState
- (void)touchesEnded:(NSSet *)touches nextStateClass:(Class)clazz;
@end