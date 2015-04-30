//
//  AppDelegate.swift
//  exposures
//
//  Created by Nicholas Addison on 28/04/2015.
//  Copyright (c) 2015 Nicholas Addison. All rights reserved.
//

import UIKit
import Parse
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    /// initialises the Parse framework.
    /// 
    /// 1. reads the ParseApplicationId and ParseClientKey user defaults from the AppSettings plist
    /// 2. registers the classes that subclass PFObject with the Parse framework
    func initializeParse(didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?)
    {
        Parse.enableLocalDatastore()
        
        let path = NSBundle.mainBundle().pathForResource("AppSettings", ofType: "plist")
        
        if let parseApplicationId: String = NSDictionary(contentsOfFile: path!)?.objectForKey("ParseApplicationId") as? String,
            let parseClientKey: String = NSDictionary(contentsOfFile: path!)?.objectForKey("ParseClientKey") as? String
        {
            NSLog("Parse Application Id \(parseApplicationId) and client key \(parseClientKey)")
            
            // Initialize Parse.
            Parse.setApplicationId(parseApplicationId, clientKey: parseClientKey)
            
            // [Optional] Track statistics around application opens.
            PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            
            // register the classes that subclass PFObject
            BankBalance.registerSubclass()
            ExchangeBalance.registerSubclass()
            Transfer.registerSubclass()
            HedgePosition.registerSubclass()
        }
        else
        {
            NSLog("Could not read Parse Application Id and/or Client Key from AppSettings plist")
        }
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        initializeParse(didFinishLaunchingWithOptions: launchOptions)
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

