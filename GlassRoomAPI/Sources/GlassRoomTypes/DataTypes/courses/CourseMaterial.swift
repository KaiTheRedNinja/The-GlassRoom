//
//  CourseMaterial.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

@available(*, deprecated, message: "This is no longer used")
public struct CourseMaterial: Codable {
    public var driveFile: DriveFile
    public var youtubeVideo: YouTubeVideo
    public var link: LinkItem
    public var form: Form
}
