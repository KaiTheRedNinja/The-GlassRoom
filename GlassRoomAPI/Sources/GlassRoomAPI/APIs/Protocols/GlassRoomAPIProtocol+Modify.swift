//
//  GlassRoomAPIProtocol+Modify.swift
//  GlassRoomAPIProtocol
//
//  Created by Kai Quan Tay on 11/5/23.
//

import Foundation

protocol GlassRoomAssigneeModifiable: GlassRoomAPIProtocol {
    associatedtype ModifyAssigneePathParameters
    associatedtype ModifyAssigneeRequestData
    associatedtype ModifyAssigneeResponseData
    static func modifyAssignees(params: ModifyAssigneePathParameters, data: ModifyAssigneeRequestData) -> ModifyAssigneeResponseData?
}

protocol GlassRoomAttachmentModifiable: GlassRoomAPIProtocol {
    associatedtype ModifyAttachmentPathParameters
    associatedtype ModifyAttachmentRequestData
    associatedtype ModifyAttachmentResponseData
    static func modifyAttachments(params: ModifyAttachmentPathParameters, data: ModifyAttachmentRequestData) -> ModifyAttachmentResponseData?
}
