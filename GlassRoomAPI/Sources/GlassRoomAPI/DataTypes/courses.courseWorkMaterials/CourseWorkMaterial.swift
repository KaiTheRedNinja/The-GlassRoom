//
//  CourseWorkMaterial.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public struct CourseWorkMaterial: Codable {
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
