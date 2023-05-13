//
//  GRAliases.swift
//  GlassRoomAPI
//
//  Created by Kai Quan Tay on 11/5/23.
//

extension GlassRoomAPI.GRCourses.GRAliases: GlassRoomCreatableDeletable, GlassRoomListable {
    public typealias CreatePathParameters = CourseIDPathParameters
    public typealias CreateQueryParameters = VoidStringCodable
    public typealias CreateRequestData = CourseAlias
    public typealias CreateResponseData = CourseAlias

    public static var apiCreatable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/aliases"

    public typealias DeletePathParameters = CourseIDAliasPathParameters
    public typealias DeleteQueryParameters = VoidStringCodable
    public typealias DeleteRequestData = VoidStringCodable
    public typealias DeleteResponseData = VoidStringCodable

    public static var apiDeletable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/aliases"

    public typealias ListPathParameters = CourseIDPathParameters
    public typealias ListQueryParameters = PageSizeTokenQueryParameters
    public typealias ListRequestData = VoidStringCodable
    public typealias ListResponseData = ListableResponseData

    public static var apiListable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/aliases"

    public struct CourseIDAliasPathParameters: StringCodable {
        public var courseId: String
        public var alias: String

        public func stringDictionaryEncoded() -> [String: String] {
            [
                "courseId": courseId,
                "alias": alias
            ]
        }
    }

    public struct PageSizeTokenQueryParameters: StringCodable {
        public var pageSize: Int
        public var pageToken: String?

        public func stringDictionaryEncoded() -> [String: String] {
            var dict = ["pageSize": pageSize.description]
            if let pageToken {
                dict["pageToken"] = pageToken
            }
            return dict
        }
    }

    public struct ListableResponseData: Codable {
        public var aliases: [CourseAlias]
        public var nextPageToken: String
    }
}
