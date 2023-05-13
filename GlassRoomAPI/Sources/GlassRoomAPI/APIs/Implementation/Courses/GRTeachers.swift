//
//  GRTeachers.swift
//  GlassRoomAPI
//
//  Created by Kai Quan Tay on 11/5/23.
//

extension GlassRoomAPI.GRCourses.GRTeachers: GlassRoomCreatableDeletable, GlassRoomGettableListable {
    public typealias CreatePathParameters = CourseIDPathParameters
    public typealias CreateQueryParameters = VoidStringCodable
    public typealias CreateRequestData = Teacher
    public typealias CreateResponseData = Teacher

    public static var apiCreatable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/teachers"

    public typealias DeletePathParameters = CourseIDTeacherPathParameters
    public typealias DeleteQueryParameters = VoidStringCodable
    public typealias DeleteRequestData = VoidStringCodable
    public typealias DeleteResponseData = VoidStringCodable

    public static var apiDeletable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/teachers/{userId}"

    public typealias GetPathParameters = CourseIDTeacherPathParameters
    public typealias GetQueryParameters = VoidStringCodable
    public typealias GetRequestData = VoidStringCodable
    public typealias GetResponseData = Teacher

    public static var apiGettable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/teachers/{userId}"

    public typealias ListPathParameters = CourseIDPathParameters
    public typealias ListQueryParameters = VoidStringCodable
    public typealias ListRequestData = VoidStringCodable
    public typealias ListResponseData = ListableResponseData

    public static var apiListable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/teachers"

    public struct CourseIDTeacherPathParameters: StringCodable {
        public var courseId: String
        public var userId: String

        public init(courseId: String, userId: String) {
            self.courseId = courseId
            self.userId = userId
        }

        public func stringDictionaryEncoded() -> [String: String] {
            [
                "courseId": courseId,
                "userId": userId
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
        public var teachers: [Teacher]
        public var nextPageToken: String?

        public init(teachers: [Teacher], nextPageToken: String) {
            self.teachers = teachers
            self.nextPageToken = nextPageToken
        }
    }
}
