//
//  Announcement.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public struct CourseAnnouncement: Codable, Equatable {
    public static func == (lhs: CourseAnnouncement, rhs: CourseAnnouncement) -> Bool {
        return lhs.id == rhs.id
    }
    // Not called Announcement since thats ambiguous
    public var courseId: String
    public var id: String
    public var text: String
    public var materials: [AssignmentMaterial]?
    public var state: AnnouncementState
    public var alternateLink: String
    public var creationTime: String
    public var updateTime: String
    public var scheduledTime: String?
    public var assigneeMode: AssigneeMode?
    public var individualStudentsOptions: IndividualStudentsOptions?
    public var creatorUserId: String
}

public extension CourseAnnouncement {
    var creationDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        if let date = dateFormatter.date(from: creationTime) {
            return date
        } else {
            Log.error("Could not get date for: \(creationTime)")
            return Date()
        }
    }
}
