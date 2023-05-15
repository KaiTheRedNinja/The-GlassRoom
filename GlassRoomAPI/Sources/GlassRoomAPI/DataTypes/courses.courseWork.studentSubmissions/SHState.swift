//
//  SHState.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public enum SHState: String, Codable { // Not called State since that already exists, SHState stands for StateHistoryState, since SubmissionState has already been taken up
    case state_unspecified = "STATE_UNSPECIFIED"
    case created = "CREATED"
    case turned_in = "TURNED_IN"
    case returned = "RETURNED"
    case reclaimed_by_student = "RECLAIMED_BY_STUDENT"
    case student_edited_after_turn_in = "STUDENT_EDITED_AFTER_TURN_IN"
}
