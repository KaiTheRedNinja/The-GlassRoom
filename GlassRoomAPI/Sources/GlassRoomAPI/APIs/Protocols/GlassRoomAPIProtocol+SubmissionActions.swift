//
//  GlassRoomAPIProtocol+SubmissionActions.swift
//  GlassRoomAPIProtocol
//
//  Created by Kai Quan Tay on 11/5/23.
//

import Foundation

protocol GlassRoomReclaimable: GlassRoomAPIProtocol {
    associatedtype ReclaimPathParameters
    associatedtype ReclaimRequestData
    associatedtype ReclaimResponseData
    static func reclaimSubmission(params: ReclaimPathParameters, data: ReclaimRequestData) -> ReclaimResponseData?
}

protocol GlassRoomReturnable: GlassRoomAPIProtocol {
    associatedtype ReturnPathParameters
    associatedtype ReturnRequestData
    associatedtype ReturnResponseData
    static func returnSubmission(params: ReturnPathParameters, data: ReturnRequestData) -> ReturnResponseData?
}

protocol GlassRoomSubmittable: GlassRoomAPIProtocol {
    associatedtype TurnInPathParameters
    associatedtype TurnInRequestData
    associatedtype TurnInResponseData
    static func turnInSubmission(params: TurnInPathParameters, data: TurnInRequestData) -> TurnInResponseData?
}
