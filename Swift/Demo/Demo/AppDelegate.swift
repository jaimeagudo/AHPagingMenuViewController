//
//  AppDelegate.swift
//  Demo
//
//  Created by André Henrique Silva on 10/05/15.
//  Copyright (c) 2015 André Henrique Silva. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate, AHPagingMenuDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let v1 = ExampleViewController()
        v1.view.backgroundColor = UIColor.blue
        let v2 = ExampleViewController()
        v2.view.backgroundColor = UIColor.black
        let v3 = Example5ViewController(nibName: "Example5ViewController", bundle: nil)
        let v4 = ExampleViewController()
        v4.view.backgroundColor = UIColor.green
        let v5 = ExampleViewController()
        v5.view.backgroundColor = UIColor.gray
        
        //Default
        // var controller = AHPagingMenuViewController(controllers: [v1,v2,v3,v4,v5], icons: ["Page 1", "Page 2", "Page 3", "Page 4", "Page 5"], position:2)

        //Like Tinder s2
        let controller = AHPagingMenuViewController(controllers: [v1,v2,v3,v4,v5], icons: NSArray(array: [UIImage(named:"photo")!,UIImage(named:"heart")!, UIImage(named:"conf")!, UIImage(named:"message")!, UIImage(named:"map")! ]), position:2)
        controller.setShowArrow(false)
        controller.setTransformScale(true)
        controller.setDissectColor(UIColor(white: 0.756, alpha: 1.0));
        controller.setSelectColor(UIColor(red: 0.963, green: 0.266, blue: 0.176, alpha: 1.000))
        
        //Nav - Icons e Strings
        //var controller = AHPagingMenuViewController(controllers: [v1,v2,v3,v4,v5], icons: NSArray(array: [UIImage(named:"photo")!,"Love", UIImage(named:"conf")!, UIImage(named:"message")!, "Map"]), position:2)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window!.rootViewController = controller
        self.window!.makeKeyAndVisible()
        
        return true;
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func AHPagingMenuDidChangeMenuFrom(_ form: AnyObject, to: AnyObject) {
        
    }
    
    func AHPagingMenuDidChangeMenuPosition(_ form: NSInteger, to: NSInteger) {
        
    }


}

