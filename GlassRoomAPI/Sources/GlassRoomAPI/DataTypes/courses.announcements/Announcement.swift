//
//  Announcement.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public struct CourseAnnouncement { // Not called Announcement since thats ambiguous
    public var courseId: String
    public var id: String
    public var text: String
    public var materials: AssignmentMaterial
    public var state: AnnouncementState
    public var alternateLink: String
    public var creationTime: String
    public var updateTime: String
    public var scheduledTime: String
    public var assigneeMode: AssigneeMode
    public var individualStudentsOptions: IndividualStudentsOptions
    public var creatorUserId: String
}
