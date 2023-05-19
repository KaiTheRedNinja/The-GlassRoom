//
//  CourseWorkType.swift
//  GlassRoomAPIProtocol
//
//  Created by Kai Quan Tay on 11/5/23.
//

import Foundation

public enum CourseWorkType: String, CaseIterable, Codable {
    case course_work_type_unspecified = "COURSE_WORK_TYPE_UNSPECIFIED"
    case assignment = "ASSIGNMENT"
    case short_answer_question = "SHORT_ANSWER_QUESTION"
    case multiple_choice_question = "MULTIPLE_CHOICE_QUESTION"
}
