//
//  TaskView.swift
//  OnlineFirstNotes
//
//  Created by Darul Firmansyah on 12/01/25.
//

import SwiftUI

struct TaskView: View {
    var task: TaskObject

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(task.title)
                    .strikethrough(task.isCompleted)
                    .font(.headline)
                    .foregroundColor(.primary)

                Spacer()

                Text(task.priority.rawValue.description)
                    .font(.subheadline)
                    .padding(4)
                    .background(task.priority.color)
                    .foregroundColor(.white)
                    .cornerRadius(5)
            }

            Text(task.desc)
                .strikethrough(task.isCompleted)
                .font(.body)
                .foregroundColor(.secondary)

            Text("Due: \(formattedDate(task.dueDate))")
                .font(.footnote)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 5)
    }

    // Function to format date
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
