//
//  Date+Extension.swift
//  AstronomyPhoto
//
//  Created by Julia Frederico on 01/12/22.
//

import Foundation

extension Date {
    
    func toString(formatter: DateFormatter = DateFormatter.api) -> String {
        return formatter.string(from: self)
    }
    
    func toString() -> String {
        let formatter = DateFormatter()

        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        formatter.locale = Locale(identifier: "en_US_POSIX")

        return formatter.string(from: self)
    }
    
}

extension String {
    
    func toDate(formatter: DateFormatter = DateFormatter.api) -> Date {
        return formatter.date(from: self) ?? Date()
    }
    
    var validDate: Bool {
        do {
            let regexString = "^(0[1-9]|1[012])[- /.](0[1-9]|[12][0-9]|3[01])[- /.](19|20)\\d\\d$"
            let regex = try NSRegularExpression(pattern: regexString)
            let matches = regex.numberOfMatches(in: self, range: self.nsRange)
            return matches > 0
        } catch {
            return false
        }
    }
    
    var nsRange: NSRange {
        return NSRange(self.startIndex..., in: self)
    }
    
}

extension DateFormatter {
    
    static let api: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    static let forms: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()

}
