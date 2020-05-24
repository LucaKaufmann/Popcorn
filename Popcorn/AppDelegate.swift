//
//  AppDelegate.swift
//  Popcorn
//
//  Created by Luca Kaufmann on 21.4.2020.
//  Copyright © 2020 mqtthings. All rights reserved.
//

import UIKit
import BackgroundTasks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        application.setMinimumBackgroundFetchInterval(1800)
        return true
    }
    
    //MARK: Regiater BackGround Tasks
    private func registerBackgroundTasks() {
        print("registering tasks")
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.hotky.setups.fetch", using: nil) { task in
            //This task is cast with processing request (BGProcessingTask)
            self.handleAppRefreshTask(task: task as! BGAppRefreshTask)
        }
        
//        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.SO.apprefresh", using: nil) { task in
//            //This task is cast with processing request (BGAppRefreshTask)
//            self.scheduleLocalNotification()
//            self.handleAppRefreshTask(task: task as! BGAppRefreshTask)
//        }
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

    
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let dataManager = DataManager()
        dataManager.refreshData(completion: {(success) in
            self.scheduleLocalNotification()
            if success {
                completionHandler(.newData)
            } else {
                completionHandler(.failed)
            }
        })
    }

    
    func handleAppRefreshTask(task: BGAppRefreshTask) {
        let dataManager = DataManager()
        dataManager.refreshData(completion: {(success) in
            task.setTaskCompleted(success: success)
            UserDefaults.standard.set(Date(), forKey: LAST_UPDATE)
        })
        scheduleBackgroundFetch()
    }
    
    func scheduleBackgroundFetch() {
        let fetchTask = BGAppRefreshTaskRequest(identifier: "com.hotky.setups.fetch")
        fetchTask.earliestBeginDate = Date(timeIntervalSinceNow: 60)
        do {
          try BGTaskScheduler.shared.submit(fetchTask)
        } catch {
          print("Unable to submit task: \(error.localizedDescription)")
        }
    }
    
    func cancelAllPandingBGTask() {
        BGTaskScheduler.shared.cancelAllTaskRequests()
    }
}

//MARK:- BGTask Helper
//extension AppDelegate {
//
//    func cancelAllPandingBGTask() {
//        BGTaskScheduler.shared.cancelAllTaskRequests()
//    }
//
//    func scheduleImageFetcher() {
//        let request = BGProcessingTaskRequest(identifier: "com.hotky.setups.fetch")
//        request.requiresNetworkConnectivity = true // Need to true if your task need to network process. Defaults to false.
//        request.requiresExternalPower = false
//
//        request.earliestBeginDate = Date(timeIntervalSinceNow: 1 * 60) // Featch Image Count after 1 minute.
//        //Note :: EarliestBeginDate should not be set to too far into the future.
//        do {
//            try BGTaskScheduler.shared.submit(request)
//        } catch {
//            print("Could not schedule image fetch: \(error)")
//        }
//    }
//
//    func handleImageFetcherTask(task: BGProcessingTask) {
//        scheduleImageFetcher() // Recall
//
//        print("Handling image fetch task")
//        //Todo Work
//        task.expirationHandler = {
//            //This Block call by System
//            //Canle your all tak's & queues
//        }
//
//        let dataManager = DataManager()
//        dataManager.refreshData(completion: {(success) in
//            task.setTaskCompleted(success: success)
//        })
//    }
//}

//MARK:- Notification Helper
extension AppDelegate {

    func registerLocalNotification() {
        let notificationCenter = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]

        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
    }

    func scheduleLocalNotification() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { (settings) in
            if settings.authorizationStatus == .authorized {
                self.fireNotification()
            }
        }
    }

    func fireNotification() {
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()

        // Configure Notification Content
        notificationContent.title = "Bg"
        notificationContent.body = "BG Notifications."

        // Add Trigger
        let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 1.0, repeats: false)

        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "local_notification", content: notificationContent, trigger: notificationTrigger)

        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }

}
