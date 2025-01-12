//
//  TaskListViewModelTests.swift
//  OnlineFirstNotes
//
//  Created by Darul Firmansyah on 12/01/25.
//
import XCTest
import Combine
@testable import OnlineFirstNotes

class TaskListViewModelTests: XCTestCase {
    var viewModel: TaskListViewModel!
    var mockTaskManager: TaskManager!
    var mockAuthenticationService: MockAuthenticationService!
    var mockNetworkService: MockNetworkService!
    var mockPresistentService: MockPersistentService!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
        
        mockPresistentService = MockPersistentService()
        mockPresistentService.savedTasks = [
            TaskObject(),
            TaskObject()
        ]
        mockNetworkService = MockNetworkService()
        mockTaskManager = TaskManager(presistentService: mockPresistentService,
                                      networkService: mockNetworkService)
        mockAuthenticationService = MockAuthenticationService()
        viewModel = TaskListViewModel(taskManager: mockTaskManager,
                                      authenticationService: mockAuthenticationService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockTaskManager = nil
        mockAuthenticationService = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testInitialTaskLoading() {
        let expectation = XCTestExpectation(description: "Tasks should be updated on initial load")
        
        // Subscribe to the tasks publisher
        viewModel.$tasks
            .dropFirst() // Ignore the initial value
            .sink { tasks in
                guard !tasks.isEmpty
                else {
                    return
                }
                // Assert the new value of tasks
                XCTAssertEqual(tasks.count, 2)
                expectation.fulfill() // Fulfill the expectation
            }
            .store(in: &cancellables)
        
        viewModel.loadTasks()
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testAddTask() {
        let expectation = XCTestExpectation(description: "Tasks should be updated after adding a new task")
        
        viewModel.$tasks
            .dropFirst() // Ignore the initial value
            .sink { tasks in
                guard !tasks.isEmpty
                else {
                    return
                }
                // Assert the new value of tasks
                XCTAssertEqual(tasks.count, 3)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.addTask(task: TaskObject())
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func testDeleteTask() {
        let expectation = XCTestExpectation(description: "Tasks should be updated after delete a task")
        
        viewModel.$tasks
            .dropFirst() // Ignore the initial value
            .sink { tasks in
                guard !tasks.isEmpty
                else {
                    return
                }
                // Assert the new value of tasks
                XCTAssertEqual(tasks.count, 1)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        let taskToDelete = mockTaskManager.tasks.first!
        viewModel.deleteTask(taskToDelete)
    }
    
    func testAuthenticationSuccess() {
        mockAuthenticationService.shouldAuthenticateSucceed = false
        viewModel.authenticate()
        
        XCTAssertFalse(viewModel.isAuthenticated)
    }
    
    func testAuthenticationFailed() {
        mockAuthenticationService.shouldAuthenticateSucceed = true
        viewModel.authenticate()
        
        XCTAssertTrue(viewModel.isAuthenticated)
    }
}
