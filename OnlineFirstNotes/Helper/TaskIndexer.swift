//
//  TaskIndexer.swift
//  OnlineFirstNotes
//
//  Created by Darul Firmansyah on 11/01/25.
//

import CoreSpotlight
import MobileCoreServices

final class TaskIndexer {
    func indexTasks(tasks: [TaskObject]) {
        var items = [CSSearchableItem]()
        
        for task in tasks {
            let uniqueIdentifier = task.id
            let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
            
            // Set attributes that you'd like to index
            attributeSet.title = task.title
            attributeSet.contentDescription = task.desc
            
            let item = CSSearchableItem(uniqueIdentifier: uniqueIdentifier, domainIdentifier: "com.yourapp.tasks", attributeSet: attributeSet)
            items.append(item)
        }
        
        CSSearchableIndex.default().indexSearchableItems(items) { error in
            if let error = error {
                print("Error indexing tasks: \(error.localizedDescription)")
            } else {
                print("Successfully indexed tasks.")
            }
        }
    }
}
