//
//  Date+Format.swift
//  todoapp
//
//  Created by VM on 11/04/21.
//  Copyright © 2021 VM. All rights reserved.
//

import Foundation

extension Date {
    func string() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd hh:mm a"
        return dateFormatter.string(from: self)
    }
    
    func timeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        return dateFormatter.string(from: self)
    }
    
    func compareToday() -> Bool {
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: dateComponents)
        return date == Date.today
    }
    
    func compareLater() -> Bool {
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: self)
        guard let date = Calendar.current.date(from: dateComponents) else {
            return false
        }
        return date > Date.today
    }
    
    static func date(for date: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmm"
        return dateFormatter.date(from: date)
    }
    
    static var today: Date = {
        var dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        dateComponents.day = 22
        dateComponents.month = 02
        dateComponents.year = 2018
        return Calendar.current.date(from: dateComponents) ?? Date()
    }()
}
