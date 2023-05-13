//
//  GlassRoomAPIProtocol+Modify.swift
//  GlassRoomAPIProtocol
//
//  Created by Kai Quan Tay on 11/5/23.
//

import Foundation

public protocol GlassRoomAssigneeModifiable: GlassRoomAPIProtocol {
    associatedtype ModifyAssigneePathParameters: StringCodable
    associatedtype ModifyAssigneeQueryParameters: StringCodable
    associatedtype ModifyAssigneeRequestData: Codable
    associatedtype ModifyAssigneeResponseData: Decodable
    static var apiAssigneeModifiable: String { get }
    static func modifyAssignees(
        params: ModifyAssigneePathParameters,
        query: ModifyAssigneeQueryParameters,
        data: ModifyAssigneeRequestData,
        completion: @escaping (Result<ModifyAssigneeResponseData, Error>) -> Void
    )
}

public protocol GlassRoomAttachmentModifiable: GlassRoomAPIProtocol {
    associatedtype ModifyAttachmentPathParameters: StringCodable
    associatedtype ModifyAttachmentQueryParameters: StringCodable
    associatedtype ModifyAttachmentRequestData: Codable
    associatedtype ModifyAttachmentResponseData: Decodable
    static var apiAttachmentModifiable: String { get }
    static func modifyAttachments(
        params: ModifyAttachmentPathParameters,
        query: ModifyAttachmentQueryParameters,
        data: ModifyAttachmentRequestData,
        completion: @escaping (Result<ModifyAttachmentResponseData, Error>) -> Void
    )
}
