//
//  AppDelegate.swift
//  TasteAtlas
//
//  Created by Tai Chin Huang on 2024/12/8.
//

import UIKit
import CoreData
import FacebookCore
import FirebaseAuth
import FirebaseCore
import GoogleSignIn
import GoogleMaps
//import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setTabBarAppearance()
        Task {
            await setupNotification()
        }
        configureFirebase()
        AppAppearance.setupAppearance()
        
        guard let infoDictionary: [String: Any] = Bundle.main.infoDictionary else {
            fatalError("Info.plist not found")
        }
        guard let apiKey: String = infoDictionary["MAPS_API_KEY"] as? String else {
            fatalError("MAPS_API_KEY not set in Info.plist")
        }
        
        GMSServices.provideAPIKey(apiKey)
        
        // Initialize Facebook SDK
        ApplicationDelegate.shared.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "TasteAtlas")
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
    
    // MARK: - TabBarAppearance
    private func setTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.primaryEarth]
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.font: UIFont.systemFont(ofSize: 12, weight: .regular)]
        appearance.stackedLayoutAppearance.selected.iconColor = .primaryEarth
        appearance.backgroundColor = .darkGrey
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().standardAppearance = appearance
    }
    
    // MARK: - Notification
    private func setupNotification() async {
        let center = UNUserNotificationCenter.current()
        // Obtain the current notification settings
        let settings = await center.notificationSettings()
        
        do {
            print("Requesting authorization")
            try await center.requestAuthorization(options: [.alert, .sound, .badge, .provisional])
        } catch {
            // Handle error here
        }
        
        // Enable or disable features based on the authorization status
        
        guard (settings.authorizationStatus == .authorized) ||
              (settings.authorizationStatus == .provisional) else { return }
        
        if settings.alertSetting == .enabled {
            print("Alerts are enabled")
            // Schedule an alert-only notification
        } else {
            print("Alerts are disabled")
            // Schedule a notification with a badge and sound
        }
    }
    
    // MARK: - Firebase
    private func configureFirebase() {
        FirebaseApp.configure()
        
//        Auth.auth().useEmulator(withHost: "localhost", port: 9099)
    }
    
    // 處理外部連結(maybe at the end of authentication process)
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
//        return ApplicationDelegate.shared.application(
//            app,
//            open: url,
//            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
//            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
//        )
    }
}
