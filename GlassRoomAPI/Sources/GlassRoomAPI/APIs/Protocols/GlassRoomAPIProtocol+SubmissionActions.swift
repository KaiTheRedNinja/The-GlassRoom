//
//  GlassRoomAPIProtocol+SubmissionActions.swift
//  GlassRoomAPIProtocol
//
//  Created by Kai Quan Tay on 11/5/23.
//

import Foundation

protocol GlassRoomReclaimable: GlassRoomAPIProtocol {
    associatedtype ReclaimRequestData
    associatedtype ReclaimResponseData
    static func reclaimSubmission(params: ReclaimRequestData) -> ReclaimResponseData?
}

protocol GlassRoomReturnable: GlassRoomAPIProtocol {
    associatedtype ReturnRequestData
    associatedtype ReturnResponseData
    static func returnSubmission(params: ReturnRequestData) -> ReturnResponseData?
}

protocol GlassRoomSubmittable: GlassRoomAPIProtocol {
    associatedtype TurnInRequestData
    associatedtype TurnInResponseData
    static func turnInSubmission(params: TurnInRequestData) -> TurnInResponseData?
}
