//
//  GlassRoomAPIProtocol.swift
//  GlassRoomAPIProtocol
//
//  Created by Kai Quan Tay on 11/5/23.
//

import Foundation

protocol GlassRoomAPIProtocol {}

protocol GlassRoomCreatableDeletable: GlassRoomCreatable, GlassRoomDeletable {}
protocol GlassRoomGettableListable: GlassRoomGettable, GlassRoomListable {}
protocol GlassRoomDeliverable: GlassRoomReclaimable, GlassRoomReturnable, GlassRoomSubmittable {}

/// Like Codable but to `[String: String]`
protocol StringCodable {
    func stringDictionaryEncoded() -> [String: String]
}

struct VoidStringCodable: StringCodable, Codable {
    func stringDictionaryEncoded() -> [String : String] { [:] }
}
