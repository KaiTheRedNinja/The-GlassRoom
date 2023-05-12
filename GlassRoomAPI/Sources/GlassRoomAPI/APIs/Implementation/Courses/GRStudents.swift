//
// .GRStudents .swift
//  GlassRoomAPI
//
//  Created by Kai Quan Tay on 11/5/23.
//

extension GlassRoomAPI.GRCourses.GRStudents: GlassRoomCreatableDeletable, GlassRoomGettableListable {
    typealias CreatePathParameters = CourseIDPathParameters
    typealias CreateQueryParameters = CreatableQueryParameters
    typealias CreateRequestData = Student
    typealias CreateResponseData = Student

    static var apiCreatable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/students"

    typealias DeletePathParameters = CourseIDStudentsPathParameters
    typealias DeleteQueryParameters = VoidStringCodable
    typealias DeleteRequestData = VoidStringCodable
    typealias DeleteResponseData = VoidStringCodable

    static var apiDeletable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/students/{userId}"

    typealias GetPathParameters = CourseIDStudentsPathParameters
    typealias GetQueryParameters = VoidStringCodable
    typealias GetRequestData = VoidStringCodable
    typealias GetResponseData = Student

    static var apiGettable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/students/{userId}"

    typealias ListPathParameters = CourseIDPathParameters
    typealias ListQueryParameters = VoidStringCodable
    typealias ListRequestData = VoidStringCodable
    typealias ListResponseData = ListableResponseData

    static var apiListable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/students"

    struct CreatableQueryParameters: StringCodable {
        var enrollmentCode: String

        func stringDictionaryEncoded() -> [String : String] {
            ["enrollmentCode": enrollmentCode]
        }
    }

    struct CourseIDStudentsPathParameters: StringCodable {
        var courseId: String
        var userId: String

        func stringDictionaryEncoded() -> [String: String] {
            [
                "courseId": courseId,
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
        var students: [Student]
        var nextPageToken: String
    }
}