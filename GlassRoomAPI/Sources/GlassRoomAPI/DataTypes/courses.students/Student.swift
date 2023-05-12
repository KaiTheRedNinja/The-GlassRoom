//
//  Student.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public struct Student: Codable {
    public var courseId: String
    public var userId: String
    public var profile: UserProfile
    public var studentWorkFolder: DriveFolder
}
