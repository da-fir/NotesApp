//
//  SceneDelegate.swift
//  OnlineFirstNotes
//
//  Created by Darul Firmansyah on 11/01/25.
//

import CoreSpotlight
import MobileCoreServices
import SwiftUI

final class SceneDelegate: NSObject, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if userActivity.activityType == CSSearchableItemActionType {
            guard let identifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String else { return }
            // Get the task associated with the identifier
            if let task = getTaskByIdentifier(identifier) {
                // TODO: Handle navigating to TaskDetailView or updating state
            }
        }
    }
    
    // Method to retrieve the task based on its identifier
    private func getTaskByIdentifier(_ identifier: String) -> TaskObject? {
        // Assuming you have a reference to your TaskManager instance
        return TaskManager().tasks.first(where: { $0.id == identifier })
    }
}
