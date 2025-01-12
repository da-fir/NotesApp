//
//  FilterView.swift
//  OnlineFirstNotes
//
//  Created by Darul Firmansyah on 12/01/25.
//

import SwiftUI

struct FilterView: View {
    @Binding var selectedPriority: Int
    @Binding var selectedCompletionStatus: Int
    @Binding var searchText: String
    @Binding var selectedDueDate: Date
    @Binding var filterShown: Bool

    var body: some View {
        VStack {
            HStack {
                Picker("Priority:", selection: $selectedPriority) {
                    Text("All").tag(0)
                    Text("High").tag(1)
                    Text("Medium").tag(2)
                    Text("Low").tag(3)
                }
                .pickerStyle(MenuPickerStyle())
            }

            Picker("Completion:", selection: $selectedCompletionStatus) {
                Text("All").tag(0)
                Text("Completed").tag(1)
                Text("Incomplete").tag(2)
            }
            .pickerStyle(MenuPickerStyle())

            DatePicker("Due Date", selection: $selectedDueDate, displayedComponents: .date)
            
            Button(action: {
                selectedPriority = 0
                selectedCompletionStatus = 0
                selectedDueDate = Date.defaultDueDate()
                filterShown = false
            }) {
                Text("Clear filter")
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(.systemGray5))
        .cornerRadius(10)
    }
}

