//
//  Course.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public struct Course: Codable, Equatable {
    
    public static func == (lhs: Course, rhs: Course) -> Bool {
        return lhs.id == rhs.id
    }
    
    public var id: String
    public var name: String
    public var section: String?
    public var descriptionHeading: String?
    public var description: String?
    public var room: String?
    public var ownerId: String
    public var creationTime: String
    public var updateTime: String
    public var enrollmentCode: String?
    public var courseState: CourseState
    public var alternateLink: String
    public var teacherGroupEmail: String
    public var courseGroupEmail: String
    public var teacherFolder: DriveFolder?
//    public var courseMaterialSets: [CourseMaterialSet] // DEPRECIATED
    public var guardiansEnabled: Bool
    public var calendarId: String?
    public var gradebookSettings: GradebookSettings
}

public extension Course {
    var creationDate: Date {

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        if let date = dateFormatter.date(from: creationTime) {
            return date
        } else {
            print("Could not get date for: \(creationTime)")
            return Date()
        }
    }

    var courseType: CourseType {
        if teacherFolder != nil {
            return .teaching
        } else {
            return .enrolled
        }
    }

    enum CourseType: String, CaseIterable {
        case teaching = "Teaching"
        case enrolled = "Enrolled"

        static public var allCases: [Course.CourseType] = [.teaching, .enrolled]
    }
}
