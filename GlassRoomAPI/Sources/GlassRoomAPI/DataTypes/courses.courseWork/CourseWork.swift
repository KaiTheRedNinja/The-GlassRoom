//
//  CourseWork.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public struct CourseWork: Codable {
    public var courseId: String
    public var id: String
    public var title: String
    public var description: String
    public var materials: [AssignmentMaterial]
    public var state: CourseWorkState
    public var alternateLink: String
    public var creationTime: String
    public var updateTime: String
    public var dueDate: DueDate
    public var dueTime: TimeOfDay
    public var scheduledTime: String
    public var maxPoints: Double
    public var workType: CourseWorkType
    public var associatedWithDeveloper: Bool
    public var assigneeMode: AssigneeMode
    public var individualStudentsOptions: IndividualStudentsOptions
    public var submissionModificationMode: SubmissionModificationMode
    public var creatorUserId: String
    public var topicId: String
    public var gradeCategory: GradeCategory
    public var assignment: Assignment
    public var multipleChoiceQuestion: MultipleChoiceQuestion
}
