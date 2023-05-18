//
//  SubmissionState.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public enum SubmissionState: String, Codable {
    case submission_state_unspecified = "SUBMISSION_STATE_UNSPECIFIED"
    case new = "NEW"
    case created = "CREATED"
    case turned_in = "TURNED_IN"
    case returned = "RETURNED"
    case reclaimed_by_student = "RECLAIMED_BY_STUDENT"
}
