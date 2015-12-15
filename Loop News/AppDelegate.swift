//
//  AppDelegate.swift
//  Loop News
//
//  Created by Andrew Munsell on 11/24/15.
//  Copyright © 2015 Loop News. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Setup APNS
        let notifSettings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        application.registerUserNotificationSettings(notifSettings)
        application.registerForRemoteNotifications()
        
        // Setup Parse
        Parse.setApplicationId("dzEbbwL3qNmZXASa9uTObhiZXE1rDONUxjrlD9LQ",
            clientKey: "fBViAezq7SPfS98ALm5kRToRpji4y1i1SJiZJNoq")
        
        PFUser.enableAutomaticUser()
        PFUser.currentUser()
        PFUser.currentUser()?.saveEventually()
        
        // Initialize the Parse objects
        Event.initialize()
        Story.initialize()
        Subscription.initialize()
        
        return true
    }
    
    /**
     * Handle APNS registration and save the token to Parse
     */
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let parseInstallation = PFInstallation.currentInstallation()
        
        parseInstallation.setDeviceTokenFromData(deviceToken)
        parseInstallation.channels = ["global", PFUser.currentUser()!.objectId!]
        
        parseInstallation.saveInBackground()
    }
    
    /**
     * Handle an incoming notification
     */
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        if application.applicationState == .Inactive {
            let notification = NSNotification(name: "showEvent", object: userInfo)
            NSNotificationCenter.defaultCenter().postNotification(notification)
        } else {
            PFPush.handlePush(userInfo)
        }
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

