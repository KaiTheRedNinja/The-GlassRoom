//
//  Attachment.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public struct Attachment: Codable, Identifiable {
    public var id = UUID()
    public var driveFile: DriveFile?
    public var youtubeVideo: YouTubeVideo?
    public var link: LinkItem?
    public var form: Form?
}
