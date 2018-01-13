//
//  DateTypeFormatter.swift
//  MicrosoftGraphSwift
//
//  Created by Aleks Vlahovic on 1/9/18.
//

import Foundation

extension DateFormatter {
    @nonobjc public static let graphDate: DateFormatter = {
        var formatter = DateFormatter()
        ///AZURE FORMAT: 0001-01-01T00:00:00Z
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }()
}

