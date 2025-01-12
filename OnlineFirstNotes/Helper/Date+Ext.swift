//
//  Date+Ext.swift
//  OnlineFirstNotes
//
//  Created by Darul Firmansyah on 12/01/25.
//

import Foundation

extension Date {
    static func defaultDueDate() -> Date {
        Calendar.current.date(byAdding: .day, value: 7, to: Date())!
    }
}
