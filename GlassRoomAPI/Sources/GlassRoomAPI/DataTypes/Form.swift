//
//  Form.swift
//  GlassRoomAPIProtocol
//
//  Created by Kai Quan Tay on 11/5/23.
//

import Foundation

public struct Form: Codable {
    public var formUrl: String
    public var responseUrl: String?
    public var title: String?
    public var thumbnailUrl: String?
}
