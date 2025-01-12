//
//  TaskManager.swift
//  OnlineFirstNotes
//
//  Created by Darul Firmansyah on 11/01/25.
//

import Foundation
import Combine

final class TaskManager: ObservableObject {
    @Published var tasks: [TaskObject] = []
    private var cancellables = Set<AnyCancellable>()
    private var pendingChanges: [TaskObject] = [] // Tracks changes made offline
    private let presistentService: PresistentServiceProtocol
    private let networkService: NetworkServiceProtocol
    
    init(presistentService: PresistentServiceProtocol = PresistentService(),
         networkService: NetworkServiceProtocol = NetworkService())
    {
        self.presistentService = presistentService
        self.networkService = networkService
        loadLocalTasks()
        fetchTasks()
    }
    
    // Load tasks from local storage
    func loadLocalTasks() {
        tasks = presistentService.loadLocalTasks()
    }
    
    // Fetch tasks from a remote service
    func fetchTasks() {
        Task { @MainActor in
            let input: [TaskObject] = try await networkService.fetchTasks()
            self.syncTasks(with: input)
        }
    }
    
    // Add a task
    func saveTask(task: TaskObject) {
        defer {
            presistentService.addTaskToDB(task: task)
        }
        
        tasks.append(task)
        pendingChanges.append(task) // Track this change for syncing
        TaskIndexer().indexTasks(tasks: tasks)
        
        Task { @MainActor in
            let _ = try await self.networkService.addTask(task: task)
        }
        
        
    }
    
    // Update a task
    func updateTask(updatedTask: TaskObject) {
        defer {
            self.presistentService.updateTaskToDB(task: updatedTask)
        }
        
        guard let index = tasks.firstIndex(where: { $0.id == updatedTask.id })
        else {
            return
        }
        tasks[index] = updatedTask
        
        TaskIndexer().indexTasks(tasks: tasks)
        pendingChanges.append(updatedTask) // Track this change for potential syncing
        
        Task { @MainActor in
            let _ = try await self.networkService.updateTask(task: updatedTask)
        }
    }
    
    // Delete a task
    func deleteTask(taskId: String) {
        tasks.removeAll { $0.id == taskId }
        
        Task { @MainActor in
            do {
                try await self.networkService.deleteTask(taskId: taskId)
                self.presistentService.deleteTask(taskId: taskId)
            } catch {
                self.presistentService.deleteTask(taskId: taskId)
            }
        }
    }
    
    func filterTasks(searchText: String?, priority: Int?, completion: Int?, dueDate: Date?) {
        tasks = presistentService.filterTasks(searchText: searchText, priority: priority, completion: completion, dueDate: dueDate)
    }
    
    // Function to sync local and remote tasks
    private func syncTasks(with remoteTasks: [TaskObject]) {
        defer {
            presistentService.saveTasksToDB(tasksArray: tasks)
        }
        
        for remoteTask in remoteTasks {
            if let localTaskIndex = tasks.firstIndex(where: { $0.id == remoteTask.id }) {
                let localTask = tasks[localTaskIndex]
                // Conflict resolution: Keep the latest modification (simplified)
                if localTask.modifiedAt < remoteTask.modifiedAt {
                    tasks[localTaskIndex] = remoteTask
                }
            } else {
                // New task from the remote service
                tasks.append(remoteTask)
            }
        }
        
        // Add pending changes to tasks
        tasks.append(contentsOf: pendingChanges)
    }
}
