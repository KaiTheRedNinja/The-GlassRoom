//
//  GlassRoomAPIProtocol+Modify.swift
//  GlassRoomAPIProtocol
//
//  Created by Kai Quan Tay on 11/5/23.
//

import Foundation

protocol GlassRoomAssigneeModifiable: GlassRoomAPIProtocol {
    associatedtype ModifyAssigneePathParameters
    associatedtype ModifyAssigneeQueryParameters
    associatedtype ModifyAssigneeRequestData
    associatedtype ModifyAssigneeResponseData
    static var apiAssigneeModifiable: String { get }
    static func modifyAssignees(params: ModifyAssigneePathParameters,
                                query: ModifyAssigneeQueryParameters,
                                data: ModifyAssigneeRequestData) -> ModifyAssigneeResponseData?
}

protocol GlassRoomAttachmentModifiable: GlassRoomAPIProtocol {
    associatedtype ModifyAttachmentPathParameters
    associatedtype ModifyAttachmentQueryParameters
    associatedtype ModifyAttachmentRequestData
    associatedtype ModifyAttachmentResponseData
    static var apiAttachmentModifiable: String { get }
    static func modifyAttachments(params: ModifyAttachmentPathParameters,
                                  query: ModifyAttachmentQueryParameters,
                                  data: ModifyAttachmentRequestData) -> ModifyAttachmentResponseData?
}
