//
//  Course.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public struct Course: Codable {
    public var id: String
    public var name: String
    public var section: String
    public var descriptionHeading: String?
    public var description: String?
    public var room: String?
    public var ownerId: String
    public var creationTime: String
    public var updateTime: String
    public var enrollmentCode: String
    public var courseState: CourseState
    public var alternateLink: String
    public var teacherGroupEmail: String
    public var courseGroupEmail: String
    public var teacherFolder: DriveFolder
    public var courseMaterialSets: [CourseMaterialSet]
    public var guardiansEnabled: Bool
    public var calendarId: String
    public var gradebookSettings: GradebookSettings
}
