//
//  SubmissionModificationMode.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public enum SubmissionModificationMode: String, Codable {
    case submission_modification_mode_unspecified = "SUBMISSION_MODIFICATION_MODE_UNSPECIFIED"
    case modifiable_until_turned_in = "MODIFIABLE_UNTIL_TURNED_IN"
    case modifiable = "MODIFIABLE"
}
