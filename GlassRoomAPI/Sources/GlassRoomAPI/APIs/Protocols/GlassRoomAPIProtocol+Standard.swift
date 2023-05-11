//
//  GlassRoomAPIProtocol+Standard.swift
//  GlassRoomAPIProtocol
//
//  Created by Kai Quan Tay on 11/5/23.
//

import Foundation

protocol GlassRoomCreatable: GlassRoomAPIProtocol {
    associatedtype CreatePathParameters
    associatedtype CreateRequestData
    associatedtype CreateResponseData
    static func create(params: CreatePathParameters, data: CreateRequestData) -> CreateResponseData?
}

protocol GlassRoomDeletable: GlassRoomAPIProtocol {
    associatedtype DeletePathParameters
    associatedtype DeleteRequestData
    associatedtype DeleteResponseData
    static func delete(params: DeletePathParameters, data: DeleteRequestData) -> DeleteResponseData?
}

protocol GlassRoomGettable: GlassRoomAPIProtocol {
    associatedtype GetPathParameters
    associatedtype GetRequestData
    associatedtype GetResponseData
    static func get(params: GetPathParameters, data: GetRequestData) -> GetResponseData?
}

protocol GlassRoomListable: GlassRoomAPIProtocol {
    associatedtype ListPathParameters
    associatedtype ListRequestData
    associatedtype ListResponseData
    static func list(params: ListPathParameters, data: ListRequestData) -> ListResponseData?
}

protocol GlassRoomPatchable: GlassRoomAPIProtocol {
    associatedtype PatchPathParameters
    associatedtype PatchRequestData
    associatedtype PatchResponseData
    static func patch(params: PatchPathParameters, data: PatchRequestData) -> PatchResponseData?
}

protocol GlassRoomUpdatable: GlassRoomAPIProtocol {
    associatedtype UpdatePathParameters
    associatedtype UpdateRequestData
    associatedtype UpdateResponseData
    static func update(params: UpdatePathParameters, data: UpdateRequestData) -> UpdateResponseData?
}
