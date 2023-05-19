//
//  Assignment.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public struct Assignment: Codable {
    public var studentWorkFolder: DriveFolder
    
    public init(studentWorkFolder: DriveFolder) {
        self.studentWorkFolder = studentWorkFolder
    }
}
