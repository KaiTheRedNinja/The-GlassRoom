//
//  CourseWork.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public struct CourseWork: Codable, Equatable {
    
    public static func == (lhs: CourseWork, rhs: CourseWork) -> Bool {
        return lhs.id == rhs.id
    }
    
    public var courseId: String
    public var id: String
    public var title: String
    public var description: String?
    public var materials: [AssignmentMaterial]?
    public var state: CourseWorkState
    public var alternateLink: String
    public var creationTime: String
    public var updateTime: String
    public var dueDate: DueDate?
    public var dueTime: TimeOfDay?
    public var scheduledTime: String?
    public var maxPoints: Double?
    public var workType: CourseWorkType
    public var associatedWithDeveloper: Bool?
    public var assigneeMode: AssigneeMode?
    public var individualStudentsOptions: IndividualStudentsOptions?
    public var submissionModificationMode: SubmissionModificationMode?
    public var creatorUserId: String
    public var topicId: String?
    public var gradeCategory: GradeCategory?
    public var assignment: Assignment?
    public var multipleChoiceQuestion: MultipleChoiceQuestion?
    
    public init(courseId: String,
                id: String,
                title: String,
                description: String? = nil,
                materials: [AssignmentMaterial]? = nil,
                state: CourseWorkState,
                alternateLink: String,
                creationTime: String,
                updateTime: String,
                dueDate: DueDate? = nil,
                dueTime: TimeOfDay? = nil,
                scheduledTime: String? = nil,
                maxPoints: Double? = nil,
                workType: CourseWorkType,
                associatedWithDeveloper: Bool? = nil,
                assigneeMode: AssigneeMode? = nil,
                individualStudentsOptions: IndividualStudentsOptions? = nil,
                submissionModificationMode: SubmissionModificationMode? = nil,
                creatorUserId: String,
                topicId: String? = nil,
                gradeCategory: GradeCategory? = nil,
                assignment: Assignment? = nil,
                multipleChoiceQuestion: MultipleChoiceQuestion? = nil
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
        self.dueDate = dueDate
        self.dueTime = dueTime
        self.scheduledTime = scheduledTime
        self.maxPoints = maxPoints
        self.workType = workType
        self.associatedWithDeveloper = associatedWithDeveloper
        self.assigneeMode = assigneeMode
        self.individualStudentsOptions = individualStudentsOptions
        self.submissionModificationMode = submissionModificationMode
        self.creatorUserId = creatorUserId
        self.topicId = topicId
        self.gradeCategory = gradeCategory
        self.assignment = assignment
        self.multipleChoiceQuestion = multipleChoiceQuestion
    }
}
