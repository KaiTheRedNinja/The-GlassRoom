//
//  Invitation.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public struct Invitation: Codable {
    public var id: String
    public var userId: String
    public var courseId: String
    public var role: CourseRole
}
