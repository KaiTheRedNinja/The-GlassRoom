//
//  AnnouncementState.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public enum AnnouncementState: String, Codable {
    case announcement_state_unspecified = "ANNOUNCEMENT_STATE_UNSPECIFIED"
    case published = "PUBLISHED"
    case draft = "DRAFT"
    case deleted = "DELETED"
}
