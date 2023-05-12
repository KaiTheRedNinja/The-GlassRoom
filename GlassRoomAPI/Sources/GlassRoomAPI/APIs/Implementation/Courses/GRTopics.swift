//
//  GRTopics.swift
//  GlassRoomAPI
//
//  Created by Kai Quan Tay on 11/5/23.
//

extension GlassRoomAPI.GRCourses.GRTopics: GlassRoomCreatableDeletable,
                                           GlassRoomGettableListable,
                                           GlassRoomPatchable {
    typealias CreatePathParameters = CourseIDPathParameters
    typealias CreateQueryParameters = VoidStringCodable
    typealias CreateRequestData = Topic
    typealias CreateResponseData = Topic

    static var apiCreatable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/topics"

    typealias DeletePathParameters = CourseIDTopicsPathParameters
    typealias DeleteQueryParameters = VoidStringCodable
    typealias DeleteRequestData = VoidStringCodable
    typealias DeleteResponseData = VoidStringCodable

    static var apiDeletable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/topics/{id}"

    typealias GetPathParameters = CourseIDTopicsPathParameters
    typealias GetQueryParameters = VoidStringCodable
    typealias GetRequestData = VoidStringCodable
    typealias GetResponseData = Topic

    static var apiGettable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/topics/{id}"

    typealias ListPathParameters = CourseIDPathParameters
    typealias ListQueryParameters = ListableQueryParameters
    typealias ListRequestData = VoidStringCodable
    typealias ListResponseData = ListableResponseData

    static var apiListable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/topics"

    typealias PatchPathParameters = CourseIDTopicsPathParameters
    typealias PatchQueryParameters = PatchableQueryParameters
    typealias PatchRequestData = Topic
    typealias PatchResponseData = Topic

    static var apiPatchable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/topics/{id}"

    struct CourseIDTopicsPathParameters: StringCodable {
        var courseId: String
        var id: String

        func stringDictionaryEncoded() -> [String: String] {
            [
                "courseId": courseId,
                "id": id
            ]
        }
    }

    struct ListableQueryParameters: StringCodable {
        var pageSize: Int?
        var pageToken: String?

        func stringDictionaryEncoded() -> [String: String] {
            var dict = [String: String]()
            if let pageSize { dict["pageSize"] = pageSize.description }
            if let pageToken { dict["pageToken"] = pageToken }
            return dict
        }
    }

    struct ListableResponseData: Codable {
        var topic: [Topic]
        var nextPageToken: String
    }

    struct PatchableQueryParameters: StringCodable {
        /// Only the following are valid: `name`
        var updateMask: [String]

        func stringDictionaryEncoded() -> [String: String] {
            ["updateMask": updateMask.joined(separator: ",")]
        }
    }
}
