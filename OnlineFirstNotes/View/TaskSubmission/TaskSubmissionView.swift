//
//  TaskSubmissionView.swift
//  OnlineFirstNotes
//
//  Created by Darul Firmansyah on 11/01/25.
//

import SwiftUI

struct TaskSubmissionView: View {
    @Environment(\.dismiss) var dismiss
    @State private var title: String = ""
    @State private var desc: String = ""
    @State private var priority: Int = 2
    @State private var isCompleted: Bool = false
    @State private var dueDate: Date = Date.defaultDueDate()
    @State private var taskId: String?
    @ObservedObject var taskManager: TaskManager
    
    let isUpdate: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("\(isUpdate ? "Update" : "New") Task")) {
                    TextField("Task Title", text: $title)
                        .autocapitalization(.words)
                    TextField("Task Desc", text: $desc)
                        .autocapitalization(.words)
                    
                    Picker("Priority", selection: $priority) {
                        Text("High").tag(1)
                        Text("Medium").tag(2)
                        Text("Low").tag(3)
                    }
                    
                    DatePicker("Due Date", selection: $dueDate, displayedComponents: .date)
                    
                    Toggle("Completed", isOn: $isCompleted)
                    
                    Button(action: {
                        saveTask()
                    }) {
                        Text("Save Task")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 6)
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    
                    if isUpdate {
                        Button(action: {
                            deleteTask()
                        }) {
                            Text("Delete Task")
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 6)
                                .background(Color.white)
                                .cornerRadius(8)
                        }
                    }
                }
            }
            .navigationTitle(isUpdate ? "Update Task" : "Add Task")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    init(task: TaskObject?, taskManager: TaskManager) {
        title = task?.title ?? ""
        desc = task?.desc ?? ""
        priority = task?.priorityRaw ?? TaskPriority.medium.rawValue
        dueDate = task?.dueDate ?? Date.defaultDueDate()
        isCompleted = task?.isCompleted ?? false
        
        self.taskManager = taskManager
        self.taskId = task?.id
        self.isUpdate = task != nil
    }
    
    private func saveTask() {
        defer {
            dismiss()
        }
        // Add the new task utilizing the task manager
        guard !title.isEmpty else { return } // Check for empty title
        let tmp = TaskObject()
        tmp.title = title
        tmp.desc = desc
        tmp.dueDate = dueDate ?? Date.defaultDueDate()
        tmp.isCompleted = isCompleted
        tmp.priority = TaskPriority(rawValue: priority) ?? .medium
        tmp.modifiedAt = Date()
        
        if isUpdate, let taskId {
            tmp.id = taskId
            taskManager.updateTask(updatedTask: tmp)
        }
        else {
            taskManager.saveTask(task: tmp)
        }
        dismiss()
    }
    
    private func deleteTask() {
        if let taskId {
            taskManager.deleteTask(taskId: taskId)
            dismiss()
        }
    }
    
}
