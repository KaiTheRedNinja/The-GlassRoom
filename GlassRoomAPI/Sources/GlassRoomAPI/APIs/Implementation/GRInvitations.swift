//
//  GRInvitations.swift
//  GlassRoomAPI
//
//  Created by Kai Quan Tay on 11/5/23.
//

extension GlassRoomAPI.GRInvitations: GlassRoomAcceptable,
                                      GlassRoomCreatableDeletable,
                                      GlassRoomGettableListable {
    public typealias AcceptPathParameters = InvitationIDPathParameter
    public typealias AcceptQueryParameters = VoidStringCodable
    public typealias AcceptRequestData = VoidStringCodable
    public typealias AcceptResponseData = VoidStringCodable
    public static var apiAcceptable: String = "https://classroom.googleapis.com/v1/invitations/{id}:accept"

    public typealias CreatePathParameters = VoidStringCodable
    public typealias CreateQueryParameters = VoidStringCodable
    public typealias CreateRequestData = Invitation
    public typealias CreateResponseData = Invitation
    public static var apiCreatable: String = "https://classroom.googleapis.com/v1/invitations"

    public typealias DeletePathParameters = InvitationIDPathParameter
    public typealias DeleteQueryParameters = VoidStringCodable
    public typealias DeleteRequestData = VoidStringCodable
    public typealias DeleteResponseData = VoidStringCodable
    public static var apiDeletable: String = "https://classroom.googleapis.com/v1/invitations/{id}"

    public typealias GetPathParameters = InvitationIDPathParameter
    public typealias GetQueryParameters = VoidStringCodable
    public typealias GetRequestData = VoidStringCodable
    public typealias GetResponseData = Invitation
    public static var apiGettable: String = "https://classroom.googleapis.com/v1/invitations/{id}"

    public typealias ListPathParameters = VoidStringCodable
    public typealias ListQueryParameters = ListableQueryParameters
    public typealias ListRequestData = VoidStringCodable
    public typealias ListResponseData = ListableResponseData
    public static var apiListable: String = "https://classroom.googleapis.com/v1/invitations"

    public struct InvitationIDPathParameter: StringCodable {
        public var id: String

        public init(id: String) {
            self.id = id
        }

        public func stringDictionaryEncoded() -> [String : String] {
            ["id": id]
        }
    }

    public struct ListableQueryParameters: StringCodable {
        public var userId: String?
        public var courseId: String?
        public var pageSize: Int?
        public var pageToken: String?

        public init(userId: String? = nil,
                    courseId: String? = nil,
                    pageSize: Int? = nil,
                    pageToken: String? = nil) {
            self.userId = userId
            self.courseId = courseId
            self.pageSize = pageSize
            self.pageToken = pageToken
        }

        public func stringDictionaryEncoded() -> [String: String] {
            var dict = [String: String]()
            if let userId { dict["userId"] = userId }
            if let courseId { dict["courseId"] = courseId }
            if let pageSize { dict["pageSize"] = pageSize.description }
            if let pageToken { dict["pageToken"] = pageToken }
            return dict
        }
    }

    public struct ListableResponseData: Codable {
        public var invitations: [Invitation]
        public var nextPageToken: String?

        public init(invitations: [Invitation], nextPageToken: String) {
            self.invitations = invitations
            self.nextPageToken = nextPageToken
        }
    }
}
