//
//  CourseState.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public enum CourseState: Codable {
    case course_state_unspecified
    case active
    case archived
    case provisioned
    case declined
    case suspended
}
