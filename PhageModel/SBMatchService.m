//
// Created by SuperPappi on 07/08/2012.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <UIKit/UIKit.h>
#import "SBMatchService.h"
#import "SBMatch.h"

@implementation SBMatchService

+ (id)matchService {
    return [[self alloc] init];
}

- (NSString *)savedMatchesPath {
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
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
    NSDictionary *plist = [match toPropertyList];
    NSData *data = [NSJSONSerialization dataWithJSONObject:plist options:0 error:nil];
    NSString *file = [self savedMatchPath:match];
    [data writeToFile:file atomically:YES];
}

- (NSString *)savedMatchPath:(SBMatch *)match {
    NSString *path = [[self savedMatchesPath] stringByAppendingPathComponent:match.matchID];
    return [path stringByAppendingPathExtension:SUFFIX];
}

- (void)deleteMatch:(SBMatch *)match {
    if (!match.isGameOver)
        @throw @"Can only delete matches that are finished";

    NSString *file = [self savedMatchPath:match];
    if ([[NSFileManager defaultManager] fileExistsAtPath:file]) {
        NSError *error;
        if (![[NSFileManager defaultManager] removeItemAtPath:file error:&error])
            @throw error;
    }
}


- (NSArray *)allMatches {

    NSString *savedMatchesPath = [self savedMatchesPath];
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:savedMatchesPath];

    NSMutableArray *matches = [NSMutableArray array];
    for (NSString *file = [dirEnum nextObject]; file; file = [dirEnum nextObject]) {
        if ([[file pathExtension] isEqualToString:SUFFIX]) {
            @try {
                NSString *path = [savedMatchesPath stringByAppendingPathComponent:file];
                NSData *data = [NSData dataWithContentsOfFile:path];
                NSDictionary *plist = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:nil];

                SBMatch *match = [SBMatch matchWithPropertyList:plist];
                if (match)
                    [matches addObject:match];
                else
                    NSLog(@"Failed to inflate match from path: %@", path);
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

- (NSArray *)activeMatches {
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id m, NSDictionary *bindings) {
        return ![(SBMatch *)m isGameOver];
    }];
    return [[self allMatches] filteredArrayUsingPredicate:predicate];
}

- (NSArray *)inactiveMatches {
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id m, NSDictionary *bindings) {
        return [(SBMatch *)m isGameOver];
    }];
    return [[self allMatches] filteredArrayUsingPredicate:predicate];
}


@end