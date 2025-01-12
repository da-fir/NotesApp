//
//  PresistentService.swift
//  OnlineFirstNotes
//
//  Created by Darul Firmansyah on 11/01/25.
//
import Foundation
import RealmSwift

protocol PresistentServiceProtocol {
    func loadLocalTasks() -> [TaskObject]
    func saveTasksToDB(tasksArray: [TaskObject])
    func addTaskToDB(task: TaskObject)
    func updateTaskToDB(task: TaskObject)
    func deleteTask(taskId: String)
    func filterTasks(searchText: String?, priority: Int?, completion: Int?, dueDate: Date?) -> [TaskObject]
}

final class PresistentService: PresistentServiceProtocol {
    private var realm: Realm
    
    init() {
        // Initialize Realm
        do {
            realm = try Realm()
        } catch {
            fatalError("Error initializing Realm: \(error)")
        }
    }
    
    func loadLocalTasks() -> [TaskObject] {
        let realmTasks = realm.objects(TaskObject.self)
        return Array(realmTasks)
    }
    
    func saveTasksToDB(tasksArray: [TaskObject]) {
        do {
            try realm.write {
                realm.add(tasksArray, update: .modified) // Add or update tasks
            }
        } catch {
            print("Error saving tasks: \(error)")
        }
    }
    
    func addTaskToDB(task: TaskObject) {
        do {
            try realm.write {
                realm.add(task)
            }
        } catch {
            print("Error adding task: \(error)")
        }
    }
    
    func updateTaskToDB(task: TaskObject) {
        do {
            try realm.write {
                realm.add(task, update: .modified)
                // Fetch the existing task and update it
                if let localTask = realm.object(ofType: TaskObject.self, forPrimaryKey: task.id) {
                    localTask.title = task.title
                    localTask.desc = task.desc
                    localTask.isCompleted = task.isCompleted
                    localTask.priority = task.priority
                    localTask.modifiedAt = Date()
                }
            }
        } catch {
            print("Error updating task: \(error)")
        }
    }
    
    func deleteTask(taskId: String) {
        do {
            if let localTask = realm.object(ofType: TaskObject.self, forPrimaryKey: taskId) {
                try realm.write {
                    realm.delete(localTask)
                }
            }
        } catch {
            print("Error deleting task: \(error)")
        }
    }
    
    func filterTasks(searchText: String?, priority: Int?, completion: Int?, dueDate: Date?) -> [TaskObject] {
        var predicates: [NSPredicate] = []
        
        if let searchText, !searchText.isEmpty {
            predicates.append(NSPredicate(format: "title CONTAINS[cd] %@ OR desc CONTAINS[cd] %@", searchText, searchText))
        }
        
        if let priority, priority > 0 {
            predicates.append(NSPredicate(format: "priorityRaw == %d", priority))
        }
        
        if let completion, completion > 0 {
            predicates.append(NSPredicate(format: "isCompleted = \(completion == 1)"))
        }
        
        if let dueDate {
            predicates.append(NSPredicate(format: "dueDate < %@", dueDate as NSDate))
        }
        
        // Combine predicates
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        let filteredTasks = realm.objects(TaskObject.self).filter(compoundPredicate)
        return Array(filteredTasks)
    }
}
