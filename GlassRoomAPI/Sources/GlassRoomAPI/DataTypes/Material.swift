//
//  Material.swift
//  GlassRoomAPIProtocol
//
//  Created by Kai Quan Tay on 11/5/23.
//

import Foundation

public struct AssignmentMaterial: Codable, Identifiable { // Not called Material since thats ambiguous
    public var id = UUID()
    public var driveFile: SharedDriveFile?
    public var youtubeVideo: YouTubeVideo?
    public var link: LinkItem?
    public var form: Form?
}
