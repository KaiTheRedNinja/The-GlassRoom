//
//  GRInvitations.swift
//  GlassRoomAPI
//
//  Created by Kai Quan Tay on 11/5/23.
//

extension GlassRoomAPI.GRInvitations: GlassRoomAcceptable,
                                      GlassRoomCreatableDeletable,
                                      GlassRoomGettableListable {
    typealias AcceptPathParameters = InvitationIDPathParameter
    typealias AcceptQueryParameters = VoidStringCodable
    typealias AcceptRequestData = VoidStringCodable
    typealias AcceptResponseData = VoidStringCodable
    static var apiAcceptable: String = "https://classroom.googleapis.com/v1/invitations/{id}:accept"

    typealias CreatePathParameters = VoidStringCodable
    typealias CreateQueryParameters = VoidStringCodable
    typealias CreateRequestData = Invitation
    typealias CreateResponseData = Invitation
    static var apiCreatable: String = "https://classroom.googleapis.com/v1/invitations"

    typealias DeletePathParameters = InvitationIDPathParameter
    typealias DeleteQueryParameters = VoidStringCodable
    typealias DeleteRequestData = VoidStringCodable
    typealias DeleteResponseData = VoidStringCodable
    static var apiDeletable: String = "https://classroom.googleapis.com/v1/invitations/{id}"

    typealias GetPathParameters = InvitationIDPathParameter
    typealias GetQueryParameters = VoidStringCodable
    typealias GetRequestData = VoidStringCodable
    typealias GetResponseData = Invitation
    static var apiGettable: String = "https://classroom.googleapis.com/v1/invitations/{id}"

    typealias ListPathParameters = VoidStringCodable
    typealias ListQueryParameters = ListableQueryParameters
    typealias ListRequestData = VoidStringCodable
    typealias ListResponseData = ListableResponseData
    static var apiListable: String = "https://classroom.googleapis.com/v1/invitations"

    struct InvitationIDPathParameter: StringCodable {
        var id: String

        func stringDictionaryEncoded() -> [String : String] {
            ["id": id]
        }
    }

    struct ListableQueryParameters: StringCodable {
        var userId: String?
        var courseId: String?
        var pageSize: Int?
        var pageToken: String?

        func stringDictionaryEncoded() -> [String: String] {
            var dict = [String: String]()
            if let userId { dict["userId"] = userId }
            if let courseId { dict["courseId"] = courseId }
            if let pageSize { dict["pageSize"] = pageSize.description }
            if let pageToken { dict["pageToken"] = pageToken }
            return dict
        }
    }

    struct ListableResponseData: Codable {
        var invitations: [Invitation]
        var nextPageToken: String
    }
}
