//
//  GRUserProfiles.swift
//  GlassRoomAPI
//
//  Created by Kai Quan Tay on 11/5/23.
//

extension GlassRoomAPI.GRUserProfiles: GlassRoomGettable {
    typealias GetPathParameters = UserProfilePathParameters
    typealias GetQueryParameters = VoidStringCodable
    typealias GetRequestData = VoidStringCodable
    typealias GetResponseData = UserProfile

    static var apiGettable: String = "https://classroom.googleapis.com/v1/userProfiles/{userId}"

    struct UserProfilePathParameters: StringCodable {
        var userId: String

        func stringDictionaryEncoded() -> [String: String] {
            ["userId": userId]
        }
    }
}
