//
//  CoursePostProtocol.swift
//  
//
//  Created by Kai Quan Tay on 22/5/23.
//

import Foundation

public protocol CoursePostProtocol {
    var creationTime: String { get }
    var updateTime: String { get }
}

extension CoursePostProtocol {
    public var creationDate: Date {
        postDateForString(string: creationTime)
    }

    public var updateDate: Date {
        postDateForString(string: updateTime)
    }
}

func postDateForString(string: String) -> Date {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")
    dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

    if let date = dateFormatter.date(from: string) {
        return date
    } else {
        Log.error("Could not get date for: \(string)")
        return Date()
    }
}

extension CourseAnnouncement: CoursePostProtocol {}
extension CourseWork: CoursePostProtocol {}
extension CourseWorkMaterial: CoursePostProtocol {}
