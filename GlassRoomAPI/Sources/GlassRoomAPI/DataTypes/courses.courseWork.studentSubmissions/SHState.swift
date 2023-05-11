//
//  SHState.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public enum SHState { // Not called State since that already exists, SHState stands for StateHistoryState, since SubmissionState has already been taken up
    case state_unspecified
    case created
    case turned_in
    case returned
    case reclaimed_by_student
    case student_edited_after_turn_in
}
