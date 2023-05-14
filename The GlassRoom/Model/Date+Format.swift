//
//  Date+Format.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 14/5/23.
//

import Foundation

func convertDate(_ dateString: String, _ dateStyle: Date.FormatStyle.DateStyle? = nil, _ timeStyle: Date.FormatStyle.TimeStyle? = nil) -> String {
    var returnDateString = ""

    if let date = dateString.iso8601withFractionalSeconds {
        guard let nonOptionalDateStyle = dateStyle else { return date.description }
        guard let nonOptionalTimeStyle = timeStyle else { return date.description }

        returnDateString = date.formatted(date: nonOptionalDateStyle, time: nonOptionalTimeStyle)
    }

    return returnDateString
}

extension ISO8601DateFormatter {
    convenience init(_ formatOptions: Options) {
        self.init()
        self.formatOptions = formatOptions
    }
}

extension Formatter {
    static let iso8601withFractionalSeconds = ISO8601DateFormatter([.withInternetDateTime, .withFractionalSeconds])
}

extension Date {
    var iso8601withFractionalSeconds: String { return Formatter.iso8601withFractionalSeconds.string(from: self) }
}

extension String {
    var iso8601withFractionalSeconds: Date? { return Formatter.iso8601withFractionalSeconds.date(from: self) }
}
