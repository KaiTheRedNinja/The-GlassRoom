//
//  GPermission.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public enum GPermission: String, Codable { // Not called Permission since that already exists, GPermission stands for GlobalPermission (but its an enum this time)
    case permission_unspecified = "PERMISSION_UNSPECIFIED"
    case create_course = "CREATE_COURSE"
}
