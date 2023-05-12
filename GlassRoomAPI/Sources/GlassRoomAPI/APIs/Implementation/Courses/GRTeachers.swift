//
//  GRTeachers.swift
//  GlassRoomAPI
//
//  Created by Kai Quan Tay on 11/5/23.
//

extension GlassRoomAPI.GRCourses.GRTeachers: GlassRoomCreatableDeletable, GlassRoomGettableListable {
    typealias CreatePathParameters = CourseIDPathParameters
    typealias CreateQueryParameters = VoidStringCodable
    typealias CreateRequestData = Teacher
    typealias CreateResponseData = Teacher

    static var apiCreatable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/teachers"

    typealias DeletePathParameters = CourseIDTeacherPathParameters
    typealias DeleteQueryParameters = VoidStringCodable
    typealias DeleteRequestData = VoidStringCodable
    typealias DeleteResponseData = VoidStringCodable

    static var apiDeletable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/teachers/{userId}"

    typealias GetPathParameters = CourseIDTeacherPathParameters
    typealias GetQueryParameters = VoidStringCodable
    typealias GetRequestData = VoidStringCodable
    typealias GetResponseData = Teacher

    static var apiGettable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/teachers/{userId}"

    typealias ListPathParameters = CourseIDPathParameters
    typealias ListQueryParameters = VoidStringCodable
    typealias ListRequestData = VoidStringCodable
    typealias ListResponseData = ListableResponseData

    static var apiListable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/teachers"

    struct CourseIDTeacherPathParameters: StringCodable {
        var courseId: String
        var userId: String

        func stringDictionaryEncoded() -> [String: String] {
            [
                "courseID": courseId,
                "userId": userId
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
        var teachers: [Teacher]
        var nextPageToken: String
    }
}
