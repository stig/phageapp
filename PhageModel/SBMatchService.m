//
// Created by SuperPappi on 07/08/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SBMatchService.h"
#import "SBMatch.h"

@implementation SBMatchService

- (NSString *)savedMatchesPath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savedMatchesPath = [documentsDirectory stringByAppendingPathComponent:@"Saved Matches"];

    NSError *error = nil;
    BOOL ok = [[NSFileManager defaultManager]
            createDirectoryAtPath:savedMatchesPath
                    withIntermediateDirectories:YES
                       attributes:@{}
                            error:&error];
    if (!ok) @throw error;

    return savedMatchesPath;
}

- (void)saveMatch:(SBMatch *)match {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:match];
    NSString *path = [[self savedMatchesPath] stringByAppendingPathComponent:match.matchID];
    NSString *file = [path stringByAppendingPathExtension:SUFFIX];
    [data writeToFile:file atomically:YES];
}

- (NSArray *)allMatches {

    NSString *savedMatchesPath = [self savedMatchesPath];
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:savedMatchesPath];

    NSMutableArray *matches = [NSMutableArray array];
    for (NSString *file = [dirEnum nextObject]; file; file = [dirEnum nextObject]) {
        if ([[file pathExtension] isEqualToString:SUFFIX]) {
            @try {
                NSString *path = [savedMatchesPath stringByAppendingPathComponent:file];
                SBMatch *match = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
                [matches addObject:match];
            }
            @catch (NSException *e) {
                NSLog(@"Caught exception: %@", e);
            }
        }
    }

    // Sort matches in order of most recently updated
    [matches sortUsingComparator:^(id aa, id bb) {
        SBMatch *a = aa, *b = bb;
        return [b.lastUpdated compare:a.lastUpdated];
    }];

    return matches;
}

@end