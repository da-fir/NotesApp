//
//  TaskListView.swift
//  OnlineFirstNotes
//
//  Created by Darul Firmansyah on 12/01/25.
//

import SwiftUI

struct TaskListView: View {
    @ObservedObject
    var viewModel: TaskListViewModel = TaskListViewModel()
    @State
    var filterShown: Bool = false
    
    var body: some View {
        NavigationView {
            if viewModel.isAuthenticated {
                List {
                    searchAndFilter
                    content
                }
                .navigationTitle("Tasks")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink(
                            destination: TaskSubmissionView(
                                task: nil,
                                taskManager: viewModel.taskManager
                            )
                        ) {
                            Text("Add")
                        }
                        .accessibilityIdentifier("LIST_ADD_BTN")
                    }
                }
            }
            else {
                VStack {
                    Text("Please authenticate using Face ID")
                    Button("Authenticate") {
                        viewModel.authenticate()
                    }
                    .padding()
                }
            }
        }
        .onAppear {
            viewModel.authenticate()
        }
    }
    
    func priorityColor(for priority: Int) -> Color {
        switch priority {
        case 1: return .red
        case 2: return .orange
        case 3: return .green
        default: return .black
        }
    }
    
    var searchAndFilter: some View {
        Group {
            SearchBar(text: $viewModel.searchText)
            Button(action: {
                filterShown.toggle()
            }) {
                Text(filterShown ? "Hide Filters" : "Show Filters")
                    .foregroundColor(.white)
            }
            
            if filterShown {
                FilterView(selectedPriority: $viewModel.selectedPriority, selectedCompletionStatus: $viewModel.selectedCompletionStatus, searchText: $viewModel.searchText, selectedDueDate: $viewModel.selectedDueDate, filterShown: $filterShown)
            }
            else {
                EmptyView()
            }
        }
    }
    
    var content: some View {
        Section {
            ForEach(viewModel.tasks) { task in
                NavigationLink(destination: TaskSubmissionView(task: task, taskManager: viewModel.taskManager)) {
                    TaskView(task: task)
                }
                .swipeActions {
                    Button(role: .destructive) {
                        viewModel.deleteTask(task)
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
        }
    }
}
