//
//  AppDelegate.m
//  Demo
//
//  Created by André Henrique Silva on 07/05/15.
//  Copyright (c) 2015 André Henrique Silva. All rights reserved.
//  Bug? Tell-me: andre.henrique@me.com http://andrehenrique.me =D
//

#import "AppDelegate.h"
#import "AHPagingMenuViewController.h"
#import "Example2ViewController.h"
#import "Example3TableViewController.h"
#import "Example4ViewController.h"
#import "Example5ViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    
    //Controllers!
    Example4ViewController *v1= [Example4ViewController new];
    Example2ViewController *v2= [Example2ViewController new];
    Example5ViewController *v3= [[Example5ViewController alloc] initWithNibName:@"Example5ViewController" bundle:nil];
    Example4ViewController *v4= [Example4ViewController new];
    Example3TableViewController *v5= [Example3TableViewController new];
    
    
    //Nav - Default
    AHPagingMenuViewController *AHController = [[AHPagingMenuViewController alloc]initWithControllers: @[v1,v2,v3,v4,v5] andMenuItens:@[@"Random Color", @"Image", @"Control",@"Randon Color 2", @"Table"] andStartWith:2];
    
    
    //Nav - Like Tinder
  /*  AHPagingMenuViewController *AHController = [[AHPagingMenuViewController alloc]initWithControllers: @[v1,v2,v3,v4,v5] andMenuItens:@[[UIImage imageNamed:@"color"], [UIImage imageNamed:@"color"],[UIImage imageNamed:@"color"],[UIImage imageNamed:@"color"], [UIImage imageNamed:@"color"]] andStartWith:2];
    [AHController setShowArrow:NO];
    [AHController setTransformScale:YES];
    [AHController setDissectedColor:[UIColor colorWithWhite:0.756 alpha:1.000]];
    [AHController setSelectedColor:[UIColor colorWithRed:0.963 green:0.266 blue:0.176 alpha:1.000]];*/
    
    
    //Nav - Icons e Strings
    /*AHPagingMenuViewController *AHController = [[AHPagingMenuViewController alloc]initWithControllers: @[v1,v2,v3,v4,v5] andMenuItens:@[[UIImage imageNamed:@"photo"],[UIImage imageNamed:@"heart"],[UIImage imageNamed:@"conf"],[UIImage imageNamed:@"message"], [UIImage imageNamed:@"map"]] andStartWith:2];
    [AHController setShowArrow:NO];
    [AHController setDissectedColor:[UIColor colorWithWhite:0.656 alpha:1.000]];
    [AHController setSelectedColor:[UIColor colorWithRed:0.963 green:0.266 blue:0.176 alpha:1.000]];
    [AHController setFade:NO];
    [AHController setTransformScale:NO];*/
    
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setWindow:self.window];
    [self.window setRootViewController:AHController];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
