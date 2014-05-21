//
//  SquareListAppDelegate.m
//  SquareList
//
//  Created by Skylar Peterson on 11/11/13.
//  Copyright (c) 2013 Class Apps. All rights reserved.
//

#import "SquareListAppDelegate.h"
#import <CoreData/CoreData.h>
#import "DatabaseAvailability.h"

@interface SquareListAppDelegate()

@property UIManagedDocument *document;

@end

#define SHOW_BADGE_KEY @"ShowBadgeIcon"
#define NUM_BADGE_KEY @"NumForBadgeIcon"

@implementation SquareListAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsDirectory = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                     inDomains:NSUserDomainMask] firstObject];
    NSString *documentName = @"MyDocument";
    NSURL *url = [documentsDirectory URLByAppendingPathComponent:documentName];
    self.document = [[UIManagedDocument alloc] initWithFileURL:url];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]) {
        [self.document openWithCompletionHandler:^(BOOL success){
            if (success) [self documentIsReady];
            if (!success) NSLog(@"Couldn't open document at %@", url);
        }];
    } else {
        [self.document saveToURL:url
                forSaveOperation:UIDocumentSaveForCreating
               completionHandler:^(BOOL success){
                   if (success) [self documentIsReady];
                   if (!success) NSLog(@"Couldn't create document at %@", url);
               }];
    }
    
    return YES;
}

- (void)documentIsReady
{
    if ([self.document documentState] == UIDocumentStateNormal) {
        NSDictionary *userInfo = self.document ? @{ DatabaseAvailabilityDocument : self.document } : nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:DatabaseAvailabilityNotification
                                                            object:self
                                                          userInfo:userInfo];
        
        NSURL *documentsDirectory = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL *storeURL = [documentsDirectory URLByAppendingPathComponent:@"CoreData.sqlite"];
        NSError *error = nil;
        NSPersistentStoreCoordinator *coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.document.managedObjectModel];
        NSDictionary *storeOptions =
        @{NSPersistentStoreUbiquitousContentNameKey: @"DoAppCloudStore"};
        NSPersistentStore *store = [coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                             configuration:nil
                                                                       URL:storeURL
                                                                   options:storeOptions
                                                                     error:&error];
        NSURL *finaliCloudURL = [store URL];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSNumber *badgeNum = [[NSUserDefaults standardUserDefaults] objectForKey:SHOW_BADGE_KEY];
    if (badgeNum.boolValue) {
        NSNumber *numForBadge = [[NSUserDefaults standardUserDefaults] objectForKey:NUM_BADGE_KEY];
        [UIApplication sharedApplication].applicationIconBadgeNumber = numForBadge.integerValue;
    } else {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
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
