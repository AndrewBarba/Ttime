//
//  TTAppDelegate.m
//  Ttime
//
//  Created by Andrew Barba on 8/5/13.
//  Copyright (c) 2013 Andrew Barba. All rights reserved.
//

#import "TTAppDelegate.h"
#import "TTMBTAService.h"
#import "TTDonationService.h"

@implementation TTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Setup Tracker
    [TTTracker sharedTracker];
    
    // Get in-app purchases ready
    [[TTDonationService sharedInstance] refreshProducts];
    
    if (TT_IS_IOS7()) {
        [self.window setTintColor:[UIColor whiteColor]];
    }    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [[TTMBTAService sharedService] stopUpdatingData];
    [[TTLocationManager sharedManager] stopUpdatingLocation];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if ([TTLocationManager locationStatus] == TTLocationStatusOkay) {
        [[TTLocationManager sharedManager] startUpdatingLocation];
        [[TTMBTAService sharedService] startUpdatingData];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
