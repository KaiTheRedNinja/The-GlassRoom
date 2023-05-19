//
//  DriveFolder.swift
//  GlassRoomAPIProtocol
//
//  Created by Kai Quan Tay on 11/5/23.
//

import Foundation

public struct DriveFolder: Codable {
    public var id: String
    public var title: String?
    public var alternateLink: String?
    
    public init(id: String, title: String? = nil, alternateLink: String? = nil) {
        self.id = id
        self.title = title
        self.alternateLink = alternateLink
    }
}
