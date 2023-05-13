//
//  GlassRoomAPIProtocol.swift
//  GlassRoomAPIProtocol
//
//  Created by Kai Quan Tay on 11/5/23.
//

import Foundation

public protocol GlassRoomAPIProtocol {}

public protocol GlassRoomCreatableDeletable: GlassRoomCreatable, GlassRoomDeletable {}
public protocol GlassRoomGettableListable: GlassRoomGettable, GlassRoomListable {}
public protocol GlassRoomDeliverable: GlassRoomReclaimable, GlassRoomReturnable, GlassRoomSubmittable {}

/// Like Codable but to `[String: String]`
public protocol StringCodable {
    func stringDictionaryEncoded() -> [String: String]
}
