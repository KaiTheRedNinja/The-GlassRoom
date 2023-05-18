//
//  GRTopics.swift
//  GlassRoomAPI
//
//  Created by Kai Quan Tay on 11/5/23.
//

import GlassRoomTypes

extension GlassRoomAPI.GRCourses.GRTopics: GlassRoomCreatableDeletable,
                                           GlassRoomGettableListable,
                                           GlassRoomPatchable {
    public typealias CreatePathParameters = CourseIDPathParameters
    public typealias CreateQueryParameters = VoidStringCodable
    public typealias CreateRequestData = Topic
    public typealias CreateResponseData = Topic

    public static var apiCreatable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/topics"

    public typealias DeletePathParameters = CourseIDTopicsPathParameters
    public typealias DeleteQueryParameters = VoidStringCodable
    public typealias DeleteRequestData = VoidStringCodable
    public typealias DeleteResponseData = VoidStringCodable

    public static var apiDeletable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/topics/{id}"

    public typealias GetPathParameters = CourseIDTopicsPathParameters
    public typealias GetQueryParameters = VoidStringCodable
    public typealias GetRequestData = VoidStringCodable
    public typealias GetResponseData = Topic

    public static var apiGettable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/topics/{id}"

    public typealias ListPathParameters = CourseIDPathParameters
    public typealias ListQueryParameters = ListableQueryParameters
    public typealias ListRequestData = VoidStringCodable
    public typealias ListResponseData = ListableResponseData

    public static var apiListable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/topics"

    public typealias PatchPathParameters = CourseIDTopicsPathParameters
    public typealias PatchQueryParameters = PatchableQueryParameters
    public typealias PatchRequestData = Topic
    public typealias PatchResponseData = Topic

    public static var apiPatchable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/topics/{id}"

    public struct CourseIDTopicsPathParameters: StringCodable {
        public var courseId: String
        public var id: String

        public init(courseId: String, id: String) {
            self.courseId = courseId
            self.id = id
        }

        public func stringDictionaryEncoded() -> [String: String] {
            [
                "courseId": courseId,
                "id": id
            ]
        }
    }

    public struct ListableQueryParameters: StringCodable {
        public var pageSize: Int?
        public var pageToken: String?

        public init(pageSize: Int? = nil, pageToken: String? = nil) {
            self.pageSize = pageSize
            self.pageToken = pageToken
        }

        public func stringDictionaryEncoded() -> [String: String] {
            var dict = [String: String]()
            if let pageSize { dict["pageSize"] = pageSize.description }
            if let pageToken { dict["pageToken"] = pageToken }
            return dict
        }
    }

    public struct ListableResponseData: Codable {
        public var topic: [Topic]
        public var nextPageToken: String?

        public init(topic: [Topic], nextPageToken: String) {
            self.topic = topic
            self.nextPageToken = nextPageToken
        }
    }

    public struct PatchableQueryParameters: StringCodable {
        /// Only the following are valid: `name`
        public var updateMask: [String]

        public init(updateMask: [String]) {
            self.updateMask = updateMask
        }

        public func stringDictionaryEncoded() -> [String: String] {
            ["updateMask": updateMask.joined(separator: ",")]
        }
    }
}
