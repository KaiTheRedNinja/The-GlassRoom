//
//  Link.swift
//  GlassRoomAPIProtocol
//
//  Created by Kai Quan Tay on 11/5/23.
//

import Foundation

public struct LinkItem: Codable { // Not called Link since that alr exists
    public var url: String
    public var title: String?
    public var thumbnailURL: String?
}
