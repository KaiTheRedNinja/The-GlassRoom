//
//  ShareMode.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public enum ShareMode: String, Codable {
    case unknown_share_mode = "UNKNOWN_SHARE_MODE"
    case view = "VIEW"
    case edit = "EDIT"
    case student_copy = "STUDENT_COPY"
}
