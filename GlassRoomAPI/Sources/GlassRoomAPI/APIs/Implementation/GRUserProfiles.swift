//
//  GRUserProfiles.swift
//  GlassRoomAPI
//
//  Created by Kai Quan Tay on 11/5/23.
//

extension GlassRoomAPI.GRUserProfiles: GlassRoomGettable {
    public typealias GetPathParameters = UserProfilePathParameters
    public typealias GetQueryParameters = VoidStringCodable
    public typealias GetRequestData = VoidStringCodable
    public typealias GetResponseData = UserProfile

    public static var apiGettable: String = "https://classroom.googleapis.com/v1/userProfiles/{userId}"

    public struct UserProfilePathParameters: StringCodable {
        public var userId: String

        public init(userId: String) {
            self.userId = userId
        }

        public func stringDictionaryEncoded() -> [String: String] {
            ["userId": userId]
        }
    }
}
