//
//  GlassRoomAPIProtocol+SubmissionActions.swift
//  GlassRoomAPIProtocol
//
//  Created by Kai Quan Tay on 11/5/23.
//

import Foundation

protocol GlassRoomReclaimable: GlassRoomAPIProtocol {
    associatedtype ReclaimPathParameters
    associatedtype ReclaimQueryParameters
    associatedtype ReclaimRequestData
    associatedtype ReclaimResponseData
    static var apiReclaimable: String { get }
    static func reclaimSubmission(params: ReclaimPathParameters,
                                  query: ReclaimQueryParameters,
                                  data: ReclaimRequestData) -> ReclaimResponseData?
}

protocol GlassRoomReturnable: GlassRoomAPIProtocol {
    associatedtype ReturnPathParameters
    associatedtype ReturnQueryParameters
    associatedtype ReturnRequestData
    associatedtype ReturnResponseData
    static var apiReturnable: String { get }
    static func returnSubmission(params: ReturnPathParameters,
                                 query: ReturnQueryParameters,
                                 data: ReturnRequestData) -> ReturnResponseData?
}

protocol GlassRoomSubmittable: GlassRoomAPIProtocol {
    associatedtype TurnInPathParameters
    associatedtype TurnInQueryParameters
    associatedtype TurnInRequestData
    associatedtype TurnInResponseData
    static var apiSubmittable: String { get }
    static func turnInSubmission(params: TurnInPathParameters,
                                 query: TurnInQueryParameters,
                                 data: TurnInRequestData) -> TurnInResponseData?
}
