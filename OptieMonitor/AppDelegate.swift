//
//  AppDelegate.swift
//  OptieMonitor
//
//  Created by André Hartman on 19/11/15.
//  Copyright © 2016 André Hartman. All rights reserved.
//
import UserNotifications
import UIKit
var dataURL = ""
var deviceTokenString = "0"
var chartFrame = CGRect(x:0, y:0, width: 0, height: 0)

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, error) in }
        application.registerForRemoteNotifications()
        
        if let notification = launchOptions?[.remoteNotification] as? [String: AnyObject] {
            print("Received: \(notification)")
        }
        applyTheme()
        // set data path
        #if targetEnvironment(simulator)
        dataURL = "http://cake.local/orders.json?id=ahartman&action="
        #else
        dataURL = "https://nastifou.synology.me:1010/orders.json?id=ahartman&action="
        #endif
        UINavigationBar.appearance().isTranslucent = false
        return true
    }
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("APNs token: \(deviceTokenString)")
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed: \(error)")
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        switch application.applicationState {
        case .inactive:
            print("Inactive")
            completionHandler(.newData)
        case .background:
            print("Background")
            completionHandler(.newData)            
        case .active:
            print("Active")
            completionHandler(.newData)
        }
        print(userInfo)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification data: [AnyHashable : Any]) {
        print("Received data: \(data)")
    }
}
