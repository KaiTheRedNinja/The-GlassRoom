//
//  GRAliases.swift
//  GlassRoomAPI
//
//  Created by Kai Quan Tay on 11/5/23.
//

extension GlassRoomAPI.GRCourses.GRAliases: GlassRoomCreatableDeletable, GlassRoomListable {
    typealias CreatePathParameters = CourseIDPathParameters
    typealias CreateQueryParameters = VoidStringCodable
    typealias CreateRequestData = CourseAlias
    typealias CreateResponseData = CourseAlias

    static var apiCreatable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/aliases"

    typealias DeletePathParameters = CourseIDAliasPathParameters
    typealias DeleteQueryParameters = VoidStringCodable
    typealias DeleteRequestData = VoidStringCodable
    typealias DeleteResponseData = VoidStringCodable

    static var apiDeletable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/aliases"

    typealias ListPathParameters = CourseIDPathParameters
    typealias ListQueryParameters = PageSizeTokenQueryParameters
    typealias ListRequestData = VoidStringCodable
    typealias ListResponseData = ListableResponseData

    static var apiListable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/aliases"

    struct CourseIDAliasPathParameters: StringCodable {
        var courseId: String
        var alias: String

        func stringDictionaryEncoded() -> [String: String] {
            [
                "courseId": courseId,
                "alias": alias
            ]
        }
    }

    struct PageSizeTokenQueryParameters: StringCodable {
        var pageSize: Int
        var pageToken: String?

        func stringDictionaryEncoded() -> [String: String] {
            var dict = ["pageSize": pageSize.description]
            if let pageToken {
                dict["pageToken"] = pageToken
            }
            return dict
        }
    }

    struct ListableResponseData: Codable {
        var aliases: [CourseAlias]
        var nextPageToken: String
    }
}
