//
//  SharedDriveFile.swift
//  
//
//  Created by Tristan on 11/05/2023.
//

import Foundation

public struct SharedDriveFile: Codable {
    public var driveFile: DriveFile
    public var shareMode: ShareMode
}
