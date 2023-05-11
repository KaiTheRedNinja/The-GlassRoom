//
//  GlassRoomAPI+SubmissionActions.swift
//  GlassRoomAPI
//
//  Created by Kai Quan Tay on 11/5/23.
//

import Foundation

protocol GlassRoomReclaimable: GlassRoomAPI {
    associatedtype ReclaimRequestData
    associatedtype ReclaimResponseData
    static func reclaimSubmission(params: ReclaimRequestData) -> ReclaimResponseData
}

protocol GlassRoomReturnable: GlassRoomAPI {
    associatedtype ReturnRequestData
    associatedtype ReturnResponseData
    static func returnSubmission(params: ReturnRequestData) -> ReturnResponseData
}

protocol GlassRoomSubmittable: GlassRoomAPI {
    associatedtype TurnInRequestData
    associatedtype TurnInResponseData
    static func turnInSubmission(params: TurnInRequestData) -> TurnInResponseData
}
