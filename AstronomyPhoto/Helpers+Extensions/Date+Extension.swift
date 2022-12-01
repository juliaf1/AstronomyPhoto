//
//  Date+Extension.swift
//  AstronomyPhoto
//
//  Created by Julia Frederico on 01/12/22.
//

import Foundation

extension Date {
    
    func toAPIString() -> String {
        return DateFormatter.api.string(from: self)
    }
    
}

extension String {
    
    func toAPIDate() -> Date {
        return DateFormatter.api.date(from: self) ?? Date()
    }
    
}

extension DateFormatter {
    
    static let api: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

}
