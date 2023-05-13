//
// .GRStudents .swift
//  GlassRoomAPI
//
//  Created by Kai Quan Tay on 11/5/23.
//

extension GlassRoomAPI.GRCourses.GRStudents: GlassRoomCreatableDeletable, GlassRoomGettableListable {
    public typealias CreatePathParameters = CourseIDPathParameters
    public typealias CreateQueryParameters = CreatableQueryParameters
    public typealias CreateRequestData = Student
    public typealias CreateResponseData = Student

    public static var apiCreatable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/students"

    public typealias DeletePathParameters = CourseIDStudentsPathParameters
    public typealias DeleteQueryParameters = VoidStringCodable
    public typealias DeleteRequestData = VoidStringCodable
    public typealias DeleteResponseData = VoidStringCodable

    public static var apiDeletable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/students/{userId}"

    public typealias GetPathParameters = CourseIDStudentsPathParameters
    public typealias GetQueryParameters = VoidStringCodable
    public typealias GetRequestData = VoidStringCodable
    public typealias GetResponseData = Student

    public static var apiGettable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/students/{userId}"

    public typealias ListPathParameters = CourseIDPathParameters
    public typealias ListQueryParameters = VoidStringCodable
    public typealias ListRequestData = VoidStringCodable
    public typealias ListResponseData = ListableResponseData

    public static var apiListable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/students"

    public struct CreatableQueryParameters: StringCodable {
        public var enrollmentCode: String

        public init(enrollmentCode: String) {
            self.enrollmentCode = enrollmentCode
        }

        public func stringDictionaryEncoded() -> [String : String] {
            ["enrollmentCode": enrollmentCode]
        }
    }

    public struct CourseIDStudentsPathParameters: StringCodable {
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
        public var students: [Student]
        public var nextPageToken: String

        public init(students: [Student], nextPageToken: String) {
            self.students = students
            self.nextPageToken = nextPageToken
        }
    }
}
