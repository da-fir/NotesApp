//
//  TaskListViewModel.swift
//  OnlineFirstNotes
//
//  Created by Darul Firmansyah on 11/01/25.
//

import SwiftUI
import Combine

final class TaskListViewModel: ObservableObject {
    @Published var tasks: [TaskObject] = []
    @Published var isAuthenticated = false
    
    @Published var searchText: String = ""
    @Published var selectedPriority: Int = 0
    @Published var selectedCompletionStatus: Int = 0
    @Published var selectedDueDate: Date = Date.defaultDueDate()
    private var cancellables = Set<AnyCancellable>()

    let taskManager: TaskManager
    let authenticationService: AuthenticationServiceProtocol
    
    init(taskManager: TaskManager = TaskManager(),
         authenticationService: AuthenticationServiceProtocol = AuthenticationService()) {
        self.taskManager = taskManager
        self.authenticationService = authenticationService
        loadTasks()
        setupBindings()
        
        taskManager.$tasks
            .assign(to: &$tasks)
    }
    
    private func setupBindings() {
        Publishers.CombineLatest4($searchText, $selectedPriority, $selectedCompletionStatus, $selectedDueDate)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] searchText, selectedPriority, selectedCompletion, selectedDueDate in
                self?.taskManager.filterTasks(searchText: searchText, priority: selectedPriority, completion: selectedCompletion, dueDate: selectedDueDate)
            }
            .store(in: &cancellables)
    }
    
    func authenticate() {
        authenticationService.authenticateUser { success in
            if success {
                self.isAuthenticated = true
                self.taskManager.loadLocalTasks()
                self.taskManager.fetchTasks()
            } else {
                // Handle authentication failure
                print("Authentication failed!")
            }
        }
    }
    
    func loadTasks() {
        // Load tasks from TaskManager
        tasks = taskManager.tasks  // Update tasks list
    }
    
    func addTask(task: TaskObject) {
        taskManager.saveTask(task: task)
    }
    
    func deleteTask(_ task: TaskObject) {
        taskManager.deleteTask(taskId: task.id)
    }
    
    func reset() {
        taskManager.loadLocalTasks()
    }
}
