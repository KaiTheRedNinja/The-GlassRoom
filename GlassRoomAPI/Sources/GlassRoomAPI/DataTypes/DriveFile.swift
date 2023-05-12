//
//  DriveFile.swift
//  GlassRoomAPIProtocol
//
//  Created by Kai Quan Tay on 11/5/23.
//

import Foundation

public struct DriveFile: Codable {
    public var id: String
    public var title: String
    public var alternateLink: String
    public var thumbnailURL: String
}
