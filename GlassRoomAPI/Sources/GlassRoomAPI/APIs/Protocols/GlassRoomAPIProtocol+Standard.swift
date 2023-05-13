//
//  GlassRoomAPIProtocol+Standard.swift
//  GlassRoomAPIProtocol
//
//  Created by Kai Quan Tay on 11/5/23.
//

import Foundation

public protocol GlassRoomCreatable: GlassRoomAPIProtocol {
    associatedtype CreatePathParameters: StringCodable
    associatedtype CreateQueryParameters: StringCodable
    associatedtype CreateRequestData: Codable
    associatedtype CreateResponseData: Decodable
    static var apiCreatable: String { get }
    static func create(
        params: CreatePathParameters,
        query: CreateQueryParameters,
        data: CreateRequestData,
        completion: @escaping (Result<CreateResponseData, Error>) -> Void
    )
}

public protocol GlassRoomDeletable: GlassRoomAPIProtocol {
    associatedtype DeletePathParameters: StringCodable
    associatedtype DeleteQueryParameters: StringCodable
    associatedtype DeleteRequestData: Codable
    associatedtype DeleteResponseData: Decodable
    static var apiDeletable: String { get }
    static func delete(
        params: DeletePathParameters,
        query: DeleteQueryParameters,
        data: DeleteRequestData,
        completion: @escaping (Result<DeleteResponseData, Error>) -> Void
    )
}

public protocol GlassRoomGettable: GlassRoomAPIProtocol {
    associatedtype GetPathParameters: StringCodable
    associatedtype GetQueryParameters: StringCodable
    associatedtype GetRequestData: Codable
    associatedtype GetResponseData: Decodable
    static var apiGettable: String { get }
    static func get(
        params: GetPathParameters,
        query: GetQueryParameters,
        data: GetRequestData,
        completion: @escaping (Result<GetResponseData, Error>) -> Void
    )
}

public protocol GlassRoomListable: GlassRoomAPIProtocol {
    associatedtype ListPathParameters: StringCodable
    associatedtype ListQueryParameters: StringCodable
    associatedtype ListRequestData: Codable
    associatedtype ListResponseData: Decodable
    static var apiListable: String { get }
    static func list(
        params: ListPathParameters,
        query: ListQueryParameters,
        data: ListRequestData,
        completion: @escaping (Result<ListResponseData, Error>) -> Void
    )
}

public protocol GlassRoomPatchable: GlassRoomAPIProtocol {
    associatedtype PatchPathParameters: StringCodable
    associatedtype PatchQueryParameters: StringCodable
    associatedtype PatchRequestData: Codable
    associatedtype PatchResponseData: Decodable
    static var apiPatchable: String { get }
    static func patch(
        params: PatchPathParameters,
        query: PatchQueryParameters,
        data: PatchRequestData,
        completion: @escaping (Result<PatchResponseData, Error>) -> Void
    )
}

public protocol GlassRoomUpdatable: GlassRoomAPIProtocol {
    associatedtype UpdatePathParameters: StringCodable
    associatedtype UpdateQueryParameters: StringCodable
    associatedtype UpdateRequestData: Codable
    associatedtype UpdateResponseData: Decodable
    static var apiUpdatable: String { get }
    static func update(
        params: UpdatePathParameters,
        query: UpdateQueryParameters,
        data: UpdateRequestData,
        completion: @escaping (Result<UpdateResponseData, Error>) -> Void
    )
}
