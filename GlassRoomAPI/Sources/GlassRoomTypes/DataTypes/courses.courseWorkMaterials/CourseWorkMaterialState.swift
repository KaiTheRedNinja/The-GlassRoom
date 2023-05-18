//
//  CourseWorkMaterialState.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import SwiftUI

public enum CourseWorkMaterialState: String, Codable {
    case coursework_material_state_unspecified = "COURSEWORK_MATERIAL_STATE_UNSPECIFIED"
    case published = "PUBLISHED"
    case draft = "DRAFT"
    case deleted = "DELETED"
}
