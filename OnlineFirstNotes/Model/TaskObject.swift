//
//  Task.swift
//  OnlineFirstNotes
//
//  Created by Darul Firmansyah on 11/01/25.
//

import Foundation
import RealmSwift
import SwiftUI

final class TaskObject: Object, Codable, Identifiable {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var title: String = ""
    @objc dynamic var desc: String = ""
    @objc dynamic var dueDate: Date = Date()
    @objc dynamic var isCompleted: Bool = false
    @objc dynamic var priorityRaw: Int = 0
    @objc dynamic var modifiedAt: Date = Date()
    
    var priority: TaskPriority {
        get {
            TaskPriority(rawValue: priorityRaw) ?? .medium
        }
        set {
            priorityRaw = newValue.rawValue
        }
    }

    // Primary Key for Realm
    override static func primaryKey() -> String? {
        return "id"
    }
}

enum TaskPriority: Int {
    case high = 1
    case medium = 2
    case low = 3
    
    init?(rawValue: Int) {
        switch rawValue {
        case 1:
            self = .high
        case 2:
            self = .medium
        case 3:
            self = .low
        default:
            self = .medium
        }
    }
    
    var color: Color {
        switch self {
        case .high:
            return .red
        case .medium:
            return .orange
        case .low:
            return .green
        }
    }
}
