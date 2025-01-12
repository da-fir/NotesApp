//
//  Mock.swift
//  OnlineFirstNotes
//
//  Created by Darul Firmansyah on 12/01/25.
//

@testable import OnlineFirstNotes
import Foundation

class MockTaskManager {
    var tasksMock: [TaskObject] = []
    
    var tasks: [TaskObject] {
        return tasksMock
    }
    
    func fetchTasks() {
        loadLocalTasks()
    }
    
    func updateTask(updatedTask: TaskObject) {
        
    }
    
    func filterTasks(searchText: String?, priority: Int?, completion: Int?, dueDate: Date?) {
        
    }
    
    func loadLocalTasks() {
        let object = TaskObject()
        object.id = "081CFCF6-D397-41B3-8773-62BAE22964F2"
        object.title = "SERVET 0"
        object.isCompleted = true
        object.priorityRaw = 3
        object.modifiedAt = Date()
        
        let object1 = TaskObject()
        object1.id = "081CFCF6-D397-41B3-8773-62BAE22964F0"
        object1.title = "SERVET 1"
        object1.isCompleted = true
        object1.priorityRaw = 1
        object1.modifiedAt = Date()
        tasksMock = [
            object,
            object1
        ]
    }
    
    func saveTask(task: TaskObject) {
        tasksMock.append(task)
    }
    
    func deleteTask(taskId: String) {
        tasksMock.removeAll { $0.id == taskId }
    }
}

class MockAuthenticationService: AuthenticationServiceProtocol {
    var shouldAuthenticateSucceed = true
    
    func authenticateUser(completion: @escaping (Bool) -> Void) {
        completion(shouldAuthenticateSucceed)
    }
}


class MockPersistentService: PresistentServiceProtocol {
    var savedTasks: [TaskObject] = []
    
    func loadLocalTasks() -> [TaskObject] {
        return savedTasks
    }
    
    func addTaskToDB(task: TaskObject) {
        savedTasks.append(task)
    }
    
    func updateTaskToDB(task: TaskObject) {
        if let index = savedTasks.firstIndex(where: { $0.id == task.id }) {
            savedTasks[index] = task
        }
    }
    
    func deleteTask(taskId: String) {
        savedTasks.removeAll { $0.id == taskId }
    }
    
    func filterTasks(searchText: String?, priority: Int?, completion: Int?, dueDate: Date?) -> [TaskObject] {
        // Simulate filtering logic
        return savedTasks.filter { task in
            (searchText == nil || task.title.contains(searchText!)) &&
            (priority == nil || task.priority.rawValue == priority) &&
            (completion == nil || task.isCompleted == (completion == 1))
        }
    }
    
    func saveTasksToDB(tasksArray: [TaskObject]) {
        // Simulate saving tasks to the database
    }
}

class MockNetworkService: NetworkServiceProtocol {
    var fetchTasksReturnValue: [TaskObject] = []
    var isFetchTasksThrowingError = false
    
    func fetchTasks() async throws -> [TaskObject] {
        if isFetchTasksThrowingError {
            throw NSError(domain: "", code: -1, userInfo: nil)
        }
        return fetchTasksReturnValue
    }
    
    func addTask(task: TaskObject) async throws -> TaskObject? {
        // Simulate adding a task
        return nil
    }
    
    func updateTask(task: TaskObject) async throws -> TaskObject? {
        // Simulate updating a task
        return nil
    }
    
    func deleteTask(taskId: String) async throws -> TaskObject? {
        // Simulate deleting a task
        return nil
    }
}
