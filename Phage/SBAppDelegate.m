//
//  SBAppDelegate.m
//  Phage
//
//  Created by Stig Brautaset on 31/07/2012.
//
//

#import "SBAppDelegate.h"

@implementation SBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [TestFlight takeOff:@"b15ebf354cbefc8afa12b65ca5ae3799_OTA1MDgyMDEyLTA1LTE5IDA4OjMwOjQ1LjQ2NzUwNQ"];

#define TESTING 1
#ifdef TESTING
    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
#endif


    NSDictionary *defaults = @{
        PLAYER_ONE_ALIAS: NSLocalizedString(@"Player 1", @"Human Player Name"),
        PLAYER_TWO_ALIAS: NSLocalizedString(@"Player 2", @"Human Player Name"),
        SGT_PEPPER_ALIAS: NSLocalizedString(@"Sgt Pepper", @"AI Player Name")
    };

    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];


    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
