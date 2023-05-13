//
//  StudentSubmission.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public struct StudentSubmission {
    public var courseId: String
    public var courseWorkId: String
    public var id: String
    public var userId: String
    public var creationTime: String
    public var updateTime: String
    public var state: SubmissionState
    public var late: Bool
    public var draftGrade: Double?
    public var assignedGrade: Double?
    public var alternateLink: String
    public var courseWorkType: CourseWorkType
    public var associatedWithDeveloper: Bool
    public var submissionHistory: [SubmissionHistory]
    public var assignmentSubmission: AssignmentSubmission
    public var shortAnswerSubmission: ShortAnswerSubmission
    public var multipleChoiceSubmission: MultipleChoiceSubmission
}
