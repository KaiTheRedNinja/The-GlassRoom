//
//  GlassRoomAPI+Modify.swift
//  GlassRoomAPI
//
//  Created by Kai Quan Tay on 11/5/23.
//

import Foundation

protocol GlassRoomAssigneeModifiable: GlassRoomAPI {
    associatedtype ModifyAssigneeRequestData
    associatedtype ModifyAssigneeResponseData
    static func modifyAssignees(params: ModifyAssigneeRequestData) -> ModifyAssigneeResponseData
}

protocol GlassRoomAttachmentModifiable: GlassRoomAPI {
    associatedtype ModifyAttachmentRequestData
    associatedtype ModifyAttachmentResponseData
    static func modifyAttachments(params: ModifyAttachmentRequestData) -> ModifyAttachmentResponseData
}
