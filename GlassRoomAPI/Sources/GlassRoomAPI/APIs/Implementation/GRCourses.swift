//
//  GRCourses.swift
//  GlassRoomAPI
//
//  Created by Kai Quan Tay on 11/5/23.
//

extension GlassRoomAPI.GRCourses: GlassRoomCreatableDeletable, GlassRoomGettableListable, GlassRoomPatchable, GlassRoomUpdatable {
    public typealias CreatePathParameters = VoidStringCodable
    public typealias CreateQueryParameters = VoidStringCodable
    public typealias CreateRequestData = Course
    public typealias CreateResponseData = Course

    public static let apiCreatable: String = "https://classroom.googleapis.com/v1/courses"

    public typealias DeletePathParameters = IDPathParameters
    public typealias DeleteQueryParameters = VoidStringCodable
    public typealias DeleteRequestData = VoidStringCodable
    public typealias DeleteResponseData = VoidStringCodable

    public static let apiDeletable: String = "https://classroom.googleapis.com/v1/courses/{id}"

    public typealias GetPathParameters = IDPathParameters
    public typealias GetQueryParameters = VoidStringCodable
    public typealias GetRequestData = VoidStringCodable
    public typealias GetResponseData = Course

    public static let apiGettable: String = "https://classroom.googleapis.com/v1/courses/{id}"

    public typealias ListPathParameters = VoidStringCodable
    public typealias ListQueryParameters = ListableQueryParameters
    public typealias ListRequestData = VoidStringCodable
    public typealias ListResponseData = ListableResponseData

    public static let apiListable: String = "https://classroom.googleapis.com/v1/courses/"

    public typealias PatchPathParameters = IDPathParameters
    public typealias PatchQueryParameters = PatchableQueryParameters
    public typealias PatchRequestData = Course
    public typealias PatchResponseData = Course

    public static let apiPatchable: String = "https://classroom.googleapis.com/v1/courses/{id}"

    public typealias UpdatePathParameters = IDPathParameters
    public typealias UpdateQueryParameters = VoidStringCodable
    public typealias UpdateRequestData = Course
    public typealias UpdateResponseData = Course

    public static let apiUpdatable: String = "https://classroom.googleapis.com/v1/courses/{id}"

    public struct IDPathParameters: StringCodable {
        public var id: String
        public func stringDictionaryEncoded() -> [String: String] { ["id": id] }

        public init(id: String) {
            self.id = id
        }
    }

    public struct ListableQueryParameters: StringCodable {
        public var studentId: String?
        public var teacherId: String?
        public var courseStates: [CourseState]?
        public var pageSize: Int?
        public var pageToken: String?

        public init(studentId: String? = nil,
                    teacherId: String? = nil,
                    courseStates: [CourseState]? = nil,
                    pageSize: Int? = nil,
                    pageToken: String? = nil) {
            self.studentId = studentId
            self.teacherId = teacherId
            self.courseStates = courseStates
            self.pageSize = pageSize
            self.pageToken = pageToken
        }

        public func stringDictionaryEncoded() -> [String: String] {
            var dict = [String: String]()
            if let studentId { dict["studentId"] = studentId }
            if let teacherId { dict["teacherId"] = teacherId }
            if let courseStates { dict["courseStates"] = courseStates.description } // TODO: Format this correctly
            if let pageSize { dict["pageSize"] = pageSize.description }
            if let pageToken { dict["pageToken"] = pageToken }
            return dict
        }
    }

    public struct ListableResponseData: Codable {
        public var courses: [Course]
        public var nextPageToken: String?

        public init(courses: [Course], nextPageToken: String) {
            self.courses = courses
            self.nextPageToken = nextPageToken
        }
    }

    public struct PatchableQueryParameters: StringCodable {
        /// Only the following are valid: `name`, `section`, `descriptionHeading`, `description`, `room`, `courseState`, `ownerId`
        public var updateMask: [String]

        public init(updateMask: [String]) {
            self.updateMask = updateMask
        }

        public func stringDictionaryEncoded() -> [String: String] {
            ["updateMask": updateMask.joined(separator: ",")]
        }
    }
}

public typealias CourseIDPathParameters = GlassRoomAPI.GRCourses.CourseIDPathParameters
public extension GlassRoomAPI.GRCourses {
    // not used within this file, but used in sub-apis.
    // functions similar to IDPathParameters but for sub-apis where its named differently.
    struct CourseIDPathParameters: StringCodable {
        public var courseId: String

        public init(courseId: String) {
            self.courseId = courseId
        }

        public func stringDictionaryEncoded() -> [String : String] {
            ["courseId": courseId]
        }
    }
}
