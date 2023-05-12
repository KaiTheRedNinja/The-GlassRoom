//
//  GlassRoomAPIProtocol+SubmissionActions.swift
//  GlassRoomAPIProtocol
//
//  Created by Kai Quan Tay on 11/5/23.
//

import Foundation

protocol GlassRoomReclaimable: GlassRoomAPIProtocol {
    associatedtype ReclaimPathParameters: StringCodable
    associatedtype ReclaimQueryParameters: StringCodable
    associatedtype ReclaimRequestData: Codable
    associatedtype ReclaimResponseData: Decodable
    static var apiReclaimable: String { get }
    static func reclaimSubmission(
        params: ReclaimPathParameters,
        query: ReclaimQueryParameters,
        data: ReclaimRequestData,
        completion: @escaping (Result<ReclaimResponseData, Error>) -> Void
    )
}

protocol GlassRoomReturnable: GlassRoomAPIProtocol {
    associatedtype ReturnPathParameters: StringCodable
    associatedtype ReturnQueryParameters: StringCodable
    associatedtype ReturnRequestData: Codable
    associatedtype ReturnResponseData: Decodable
    static var apiReturnable: String { get }
    static func returnSubmission(
        params: ReturnPathParameters,
        query: ReturnQueryParameters,
        data: ReturnRequestData,
        completion: @escaping (Result<ReturnResponseData, Error>) -> Void
    )
}

protocol GlassRoomSubmittable: GlassRoomAPIProtocol {
    associatedtype TurnInPathParameters: StringCodable
    associatedtype TurnInQueryParameters: StringCodable
    associatedtype TurnInRequestData: Codable
    associatedtype TurnInResponseData: Decodable
    static var apiSubmittable: String { get }
    static func turnInSubmission(
        params: TurnInPathParameters,
        query: TurnInQueryParameters,
        data: TurnInRequestData,
        completion: @escaping (Result<TurnInResponseData, Error>) -> Void
    )
}
