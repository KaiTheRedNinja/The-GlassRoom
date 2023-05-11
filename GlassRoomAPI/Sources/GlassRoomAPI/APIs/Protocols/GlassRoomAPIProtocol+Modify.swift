//
//  GlassRoomAPIProtocol+Modify.swift
//  GlassRoomAPIProtocol
//
//  Created by Kai Quan Tay on 11/5/23.
//

import Foundation

protocol GlassRoomAssigneeModifiable: GlassRoomAPIProtocol {
    associatedtype ModifyAssigneeRequestData
    associatedtype ModifyAssigneeResponseData
    static func modifyAssignees(params: ModifyAssigneeRequestData) -> ModifyAssigneeResponseData?
}

protocol GlassRoomAttachmentModifiable: GlassRoomAPIProtocol {
    associatedtype ModifyAttachmentRequestData
    associatedtype ModifyAttachmentResponseData
    static func modifyAttachments(params: ModifyAttachmentRequestData) -> ModifyAttachmentResponseData?
}
