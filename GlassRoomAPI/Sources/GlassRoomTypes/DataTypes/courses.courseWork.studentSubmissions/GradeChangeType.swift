//
//  GradeChangeType.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public enum GradeChangeType: String, Codable {
    case unknown_grade_change_type = "UNKNOWN_GRADE_CHANGE_TYPE"
    case draft_grade_points_earned_change = "DRAFT_GRADE_POINTS_EARNED_CHANGE"
    case assigned_grade_points_earned_change = "ASSIGNED_GRADE_POINTS_EARNED_CHANGE"
    case max_points_change = "MAX_POINTS_CHANGE"
}
