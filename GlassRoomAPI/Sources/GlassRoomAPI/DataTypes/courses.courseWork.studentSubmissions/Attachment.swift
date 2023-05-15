//
//  Attachment.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public struct Attachment: Codable {
    public var driveFile: SharedDriveFile
    public var youtubeVideo: YouTubeVideo
    public var link: LinkItem
    public var form: Form
}
