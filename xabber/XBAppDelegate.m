//
//  XBAppDelegate.m
//  xabber
//
//  Created by Dmitry Sobolev on 15/08/14.
//  Copyright (c) 2014 Redsolution LLC. All rights reserved.
//

#import "XBAppDelegate.h"

#import "SSKeychain.h"
#import "XBAccountManager.h"
#import "XBAccount.h"

@implementation XBAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:[MagicalRecord defaultStoreName]];

    [SSKeychain setAccessibilityType:kSecAttrAccessibleWhenUnlocked];

    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = (UISplitViewController *)self.window.rootViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        splitViewController.delegate = (id)navigationController.topViewController;
        
        UINavigationController *masterNavigationController = splitViewController.viewControllers[0];
//        XBMasterViewController *controller = (XBMasterViewController *)masterNavigationController.topViewController;
    } else {
        UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
//        XBMasterViewController *controller = (XBMasterViewController *)navigationController.topViewController;
    }

    [[XBAccountManager sharedInstance] loginToEnabledAccounts];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeConnectionStateIfChangedAuthLoginProperty:) name:XBAccountManagerAccountAdded object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeConnectionStateIfChangedAuthLoginProperty:) name:XBAccountManagerAccountDeleted object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeConnectionStateIfChangedAuthLoginProperty:) name:XBAccountSaved object:nil];

    return YES;
}

- (void)changeConnectionStateIfChangedAuthLoginProperty:(NSNotification *)notification {
    XBAccount *account = notification.userInfo[@"account"];

    if (account.autoLogin && account.state == XBConnectionStateOffline) {
        [account login];
    }

    if (!account.autoLogin && account.state == XBConnectionStateOnline) {
        [account logout];
    }
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
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = [NSManagedObjectContext defaultContext];
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
             // Replace this implementation with code to handle the error appropriately.
             // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
