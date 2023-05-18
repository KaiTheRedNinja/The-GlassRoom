//
//  CourseState.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public enum CourseState: String, Codable {
    case course_state_unspecified = "COURSE_STATE_UNSPECIFIED"
    case active = "ACTIVE"
    case archived = "ARCHIVED"
    case provisioned = "PROVISIONED"
    case declined = "DECLINED"
    case suspended = "SUSPENDED"
}
