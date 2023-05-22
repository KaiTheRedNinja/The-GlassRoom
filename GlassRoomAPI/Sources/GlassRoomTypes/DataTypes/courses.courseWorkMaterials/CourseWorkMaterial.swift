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
    
    public init(courseId: String,
                id: String,
                title: String,
                description: String? = nil,
                materials: [AssignmentMaterial]? = nil,
                state: CourseWorkMaterialState,
                alternateLink: String,
                creationTime: String,
                updateTime: String,
                scheduledTime: String? = nil,
                assigneeMode: AssigneeMode? = nil,
                individualStudentsOptions: IndividualStudentsOptions? = nil,
                creatorUserId: String,
                topicId: String? = nil
    ) {
        self.courseId = courseId
        self.id = id
        self.title = title
        self.description = description
        self.materials = materials
        self.state = state
        self.alternateLink = alternateLink
        self.creationTime = creationTime
        self.updateTime = updateTime
        self.scheduledTime = scheduledTime
        self.assigneeMode = assigneeMode
        self.individualStudentsOptions = individualStudentsOptions
        self.creatorUserId = creatorUserId
        self.topicId = topicId
    }
}
