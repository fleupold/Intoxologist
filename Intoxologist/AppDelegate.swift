//
//  AppDelegate.swift
//  Intoxologist
//
//  Created by Felix Leupold on 23/01/17.
//  Copyright © 2017 Felix Leupold. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  var notificationPoster: NotificationPoster!
  
  func application(_: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    self.window = UIWindow(frame: UIScreen.main.bounds)
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let viewController = storyboard.instantiateViewController(withIdentifier: "CalendarView") as! ViewController

    // Override point for customization after application launch.
    let recordStore = DrinkingRecordStore(userDefaults: .standard,
                                          listener: viewController)
    
    viewController.recordStore = recordStore
    
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.removeAllDeliveredNotifications()
    
    notificationPoster = NotificationPoster(notificationCenter: notificationCenter,
                                                recordStore: recordStore);
    notificationCenter.delegate = notificationPoster
    
    notificationPoster.requestNotificationPermissions()
    notificationPoster.scheduleNotification()
    
    self.window?.rootViewController = viewController
    self.window?.makeKeyAndVisible()
    return true
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
  
  
}

