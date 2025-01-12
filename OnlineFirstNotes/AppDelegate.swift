//
//  TaskIndexer.swift
//  OnlineFirstNotes
//
//  Created by Darul Firmansyah on 11/01/25.
//
import Foundation
import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
    var tasks: [TaskObject] = []
    
    // Function to configure the initial setup if needed.
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Perform any additional setup after launching
        return true
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        let sceneConfig: UISceneConfiguration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
        sceneConfig.delegateClass = SceneDelegate.self
        return sceneConfig
    }
}

extension Notification.Name {
    static let didSelectTask = Notification.Name("didSelectTask")
}
