//
//  AppDelegate.swift
//  KitabMubin
//
//  Created by MoamenHalanMac on 24/07/2022.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import MOLH
import FirebaseCore
import FirebaseMessaging
import AVFoundation
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let gcmMessageIDKey = "gcm.Message_ID"
 
    var window:UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupIQKeyboardManagerAppearance()
        setNavigationBarStyle()
        initViewWindow()
        addMOLHConfig()
        migrateRealm()
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
        
        UIView.appearance().semanticContentAttribute = .forceRightToLeft
        LocationService.shared.startUpdatingLocation()
        audioPlayingInBackground()
        return true
    }
    
    
    private func migrateRealm() {
        RealmConfigure.migrate()
    }
    
    private func setNavigationBarStyle() {
        let navigationBarAppearace = UINavigationBar.appearance()
        let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.KMTextColor, NSAttributedString.Key.font: UIFont(name: "Tajawal-Medium", size: 15) ?? UIFont()] as [NSAttributedString.Key : Any]
        let largeTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.KMTextColor, NSAttributedString.Key.font: UIFont(name: "Tajawal-Bold", size: 30) ?? UIFont()] as [NSAttributedString.Key : Any]
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.shadowImage = UIImage()
            appearance.shadowColor = .clear
            appearance.titleTextAttributes = textAttributes as [NSAttributedString.Key : Any]
            appearance.largeTitleTextAttributes = largeTextAttributes
            navigationBarAppearace.standardAppearance = appearance
            navigationBarAppearace.standardAppearance = appearance
        } else {
            navigationBarAppearace.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
            navigationBarAppearace.shadowImage = UIImage()
        }
        navigationBarAppearace.titleTextAttributes = textAttributes
        navigationBarAppearace.largeTitleTextAttributes = largeTextAttributes
        navigationBarAppearace.barTintColor = UIColor.white
        navigationBarAppearace.tintColor = .KMGreanBackGround
    }
    
    private func addMOLHConfig() {
//        MOLHLanguage.setDefaultLanguage("en")
//        MOLH.shared.activate(true)
//        MOLH.shared.specialKeyWords = ["Cancel","Done"]
    }
    
    private func initViewWindow() {
        let mainSB = UIStoryboard(name: "Main", bundle: nil)
        let tabBar = mainSB.instantiateViewController(withIdentifier: "MainTabBar") as! UITabBarController
        window?.rootViewController = BaseNavigationController(tabBar)
        window?.makeKeyAndVisible()
    }
    
    private func setupIQKeyboardManagerAppearance() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = true
        IQKeyboardManager.shared.toolbarTintColor = .systemIndigo
        IQKeyboardManager.shared.shouldPlayInputClicks = true
    }
    
    private func audioPlayingInBackground(){
        let audioSession = AVAudioSession.sharedInstance()
        do {
          try audioSession.setCategory(.playback, mode: .moviePlayback)
        }
        catch {
          print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
    }
    
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "KitabMubin")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

// MARK: - UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async
    -> UNNotificationPresentationOptions {
        let userInfo = notification.request.content.userInfo
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // ...
        
        // Print full message.
        print(userInfo)
        
        // Change this to your preferred presentation option
        return [[.alert, .sound]]
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        
        // ...
        
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        // Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any]) async
      -> UIBackgroundFetchResult {
      // If you are receiving a notification message while your app is in the background,
      // this callback will not be fired till the user taps on the notification launching the application.
      // TODO: Handle data of notification

      // With swizzling disabled you must let Messaging know about the message, for Analytics
      // Messaging.messaging().appDidReceiveMessage(userInfo)

      // Print message ID.
      if let messageID = userInfo[gcmMessageIDKey] {
        print("Message ID: \(messageID)")
      }

      // Print full message.
      print(userInfo)

      return UIBackgroundFetchResult.newData
    }
 
}

 
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        
        let dataDict: [String: String] = ["token": fcmToken ?? ""]
        NotificationCenter.default.post(
            name: Notification.Name("FCMToken"),
            object: nil,
            userInfo: dataDict
        )
        // TODO: If necessary send token to application server.
        // Note: This callback is fired at each app startup and whenever a new token is generated.
    }
    
}
