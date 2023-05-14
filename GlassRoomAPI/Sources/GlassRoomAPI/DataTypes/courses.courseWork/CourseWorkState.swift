//
//  CourseWorkState.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public enum CourseWorkState: String, Codable {
    case course_work_state_unspecified = "COURSE_WORK_STATE_UNSPECIFIED"
    case published = "PUBLISHED"
    case draft = "DRAFT"
    case deleted = "DELETED"
}
