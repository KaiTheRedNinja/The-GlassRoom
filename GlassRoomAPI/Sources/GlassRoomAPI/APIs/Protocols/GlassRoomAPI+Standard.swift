//
//  GlassRoomAPI+Standard.swift
//  GlassRoomAPI
//
//  Created by Kai Quan Tay on 11/5/23.
//

import Foundation

protocol GlassRoomCreatable: GlassRoomAPI {
    associatedtype CreateRequestData
    associatedtype CreateResponseData
    static func create(params: CreateRequestData) -> CreateResponseData
}

protocol GlassRoomDeletable: GlassRoomAPI {
    associatedtype DeleteRequestData
    associatedtype DeleteResponseData
    static func delete(params: DeleteRequestData) -> DeleteResponseData
}

protocol GlassRoomGettable: GlassRoomAPI {
    associatedtype GetRequestData
    associatedtype GetResponseData
    static func get(params: GetRequestData) -> GetResponseData
}

protocol GlassRoomListable: GlassRoomAPI {
    associatedtype ListRequestData
    associatedtype ListResponseData
    static func list(params: ListRequestData) -> ListResponseData
}

protocol GlassRoomPatchable: GlassRoomAPI {
    associatedtype PatchRequestData
    associatedtype PatchResponseData
    static func patch(params: PatchRequestData) -> PatchResponseData
}

protocol GlassRoomUpdatable: GlassRoomAPI {
    associatedtype UpdateRequestData
    associatedtype UpdateResponseData
    static func update(params: UpdateRequestData) -> UpdateResponseData
}
