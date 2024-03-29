//
//  Date+Conversion.swift
//
//
//  Created by Kai Quan Tay on 12/10/23.
//

import Foundation

public func convertDate(_ dateString: String, _ dateStyle: Date.FormatStyle.DateStyle? = nil, _ timeStyle: Date.FormatStyle.TimeStyle? = nil) -> String {
    var returnDateString = ""

    if let date = dateString.iso8601withFractionalSeconds {
        guard let nonOptionalDateStyle = dateStyle else { return date.description }
        guard let nonOptionalTimeStyle = timeStyle else { return date.description }

        returnDateString = date.formatted(date: nonOptionalDateStyle, time: nonOptionalTimeStyle)
    } else if let date = dateString.iso8601withoutFractionalSeconds {
        guard let nonOptionalDateStyle = dateStyle else { return date.description }
        guard let nonOptionalTimeStyle = timeStyle else { return date.description }

        returnDateString = date.formatted(date: nonOptionalDateStyle, time: nonOptionalTimeStyle)
    }

    return returnDateString
}

public extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options) {
        self.init()
        self.formatOptions = formatOptions
    }
}

public extension Formatter {
    static let iso8601withFractionalSeconds = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
    static let iso8601withoutFractionalSeconds = ISO8601DateFormatter([.withInternetDateTime])
}

public extension Date {
    var iso8601withFractionalSeconds: String { return Formatter.iso8601withFractionalSeconds.string(from: self) }
    var iso8601withoutFractionalSeconds: String { return Formatter.iso8601withoutFractionalSeconds.string(from: self) }
}

public extension String {
    var iso8601withFractionalSeconds: Date? { return Formatter.iso8601withFractionalSeconds.date(from: self) }
    var iso8601withoutFractionalSeconds: Date? { return Formatter.iso8601withoutFractionalSeconds.date(from: self) }
}
