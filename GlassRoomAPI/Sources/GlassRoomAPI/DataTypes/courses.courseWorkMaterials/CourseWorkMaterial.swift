//
//  CourseWorkMaterial.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public struct CourseWorkMaterial: Codable, Equatable {
    public static func == (lhs: CourseWorkMaterial, rhs: CourseWorkMaterial) -> Bool {
        return lhs.id == rhs.id
    }
    
      public var courseId: String
      public var id: String
      public var title: String
      public var description: String?
      public var materials: [AssignmentMaterial]?
      public var state: CourseWorkMaterialState
      public var alternateLink: String
      public var creationTime: String
      public var updateTime: String
      public var scheduledTime: String?
      public var assigneeMode: AssigneeMode?
      public var individualStudentsOptions: IndividualStudentsOptions?
      public var creatorUserId: String
      public var topicId: String?
}

public extension CourseWorkMaterial {
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
}
