//
//  GlassRoomAPIProtocol+Standard.swift
//  GlassRoomAPIProtocol
//
//  Created by Kai Quan Tay on 11/5/23.
//

import Foundation

protocol GlassRoomCreatable: GlassRoomAPIProtocol {
    associatedtype CreateRequestData
    associatedtype CreateResponseData
    static func create(params: CreateRequestData) -> CreateResponseData?
}

protocol GlassRoomDeletable: GlassRoomAPIProtocol {
    associatedtype DeleteRequestData
    associatedtype DeleteResponseData
    static func delete(params: DeleteRequestData) -> DeleteResponseData?
}

protocol GlassRoomGettable: GlassRoomAPIProtocol {
    associatedtype GetRequestData
    associatedtype GetResponseData
    static func get(params: GetRequestData) -> GetResponseData?
}

protocol GlassRoomListable: GlassRoomAPIProtocol {
    associatedtype ListRequestData
    associatedtype ListResponseData
    static func list(params: ListRequestData) -> ListResponseData?
}

protocol GlassRoomPatchable: GlassRoomAPIProtocol {
    associatedtype PatchRequestData
    associatedtype PatchResponseData
    static func patch(params: PatchRequestData) -> PatchResponseData?
}

protocol GlassRoomUpdatable: GlassRoomAPIProtocol {
    associatedtype UpdateRequestData
    associatedtype UpdateResponseData
    static func update(params: UpdateRequestData) -> UpdateResponseData?
}
