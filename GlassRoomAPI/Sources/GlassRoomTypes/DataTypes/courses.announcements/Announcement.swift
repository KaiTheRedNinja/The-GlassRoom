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
    
    public init(courseId:
                String,
                id: String,
                text: String,
                materials: [AssignmentMaterial]? = nil,
                state: AnnouncementState,
                alternateLink: String,
                creationTime: String,
                updateTime: String,
                scheduledTime: String? = nil,
                assigneeMode: AssigneeMode? = nil,
                individualStudentsOptions: IndividualStudentsOptions? = nil,
                creatorUserId: String
    ) {
        self.courseId = courseId
        self.id = id
        self.text = text
        self.materials = materials
        self.state = state
        self.alternateLink = alternateLink
        self.creationTime = creationTime
        self.updateTime = updateTime
        self.scheduledTime = scheduledTime
        self.assigneeMode = assigneeMode
        self.individualStudentsOptions = individualStudentsOptions
        self.creatorUserId = creatorUserId
    }
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
