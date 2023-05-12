//
//  GRCourses.swift
//  GlassRoomAPI
//
//  Created by Kai Quan Tay on 11/5/23.
//

extension GlassRoomAPI.GRCourses: GlassRoomCreatableDeletable, GlassRoomGettableListable, GlassRoomPatchable, GlassRoomUpdatable {
    typealias CreatePathParameters = VoidStringCodable
    typealias CreateQueryParameters = VoidStringCodable
    typealias CreateRequestData = Course
    typealias CreateResponseData = Course

    static let apiCreatable: String = "https://classroom.googleapis.com/v1/courses"

    typealias DeletePathParameters = IDPatchParameters
    typealias DeleteQueryParameters = VoidStringCodable
    typealias DeleteRequestData = VoidStringCodable
    typealias DeleteResponseData = VoidStringCodable

    static let apiDeletable: String = "https://classroom.googleapis.com/v1/courses/{id}"

    typealias GetPathParameters = IDPatchParameters
    typealias GetQueryParameters = VoidStringCodable
    typealias GetRequestData = VoidStringCodable
    typealias GetResponseData = Course

    static let apiGettable: String = "https://classroom.googleapis.com/v1/courses/{id}"

    typealias ListPathParameters = VoidStringCodable
    typealias ListQueryParameters = ListableQueryParameters
    typealias ListRequestData = VoidStringCodable
    typealias ListResponseData = ListableResponseData

    static let apiListable: String = "https://classroom.googleapis.com/v1/courses/"

    typealias PatchPathParameters = IDPatchParameters
    typealias PatchQueryParameters = PatchableQueryParameters
    typealias PatchRequestData = Course
    typealias PatchResponseData = Course

    static let apiPatchable: String = "https://classroom.googleapis.com/v1/courses/{id}"

    typealias UpdatePathParameters = IDPatchParameters
    typealias UpdateQueryParameters = VoidStringCodable
    typealias UpdateRequestData = Course
    typealias UpdateResponseData = Course

    static let apiUpdatable: String = "https://classroom.googleapis.com/v1/courses/{id}"

    struct IDPatchParameters: StringCodable {
        var id: String
        func stringDictionaryEncoded() -> [String: String] { ["id": id] }
    }

    struct ListableQueryParameters: StringCodable {
        var studentId: String?
        var teacherId: String?
        var courseStates: [CourseState]?
        var pageSize: Int?
        var pageToken: String?

        func stringDictionaryEncoded() -> [String: String] {
            var dict = [String: String]()
            if let studentId { dict["studentId"] = studentId }
            if let teacherId { dict["teacherId"] = teacherId }
            if let courseStates { dict["courseStates"] = courseStates.description } // TODO: Format this correctly
            if let pageSize { dict["pageSize"] = pageSize.description }
            if let pageToken { dict["pageToken"] = pageToken }
            return dict
        }
    }

    struct ListableResponseData: Codable {
        var courses: Course
        var nextPageToken: String
    }

    struct PatchableQueryParameters: StringCodable {
        /// Only the following are valid: `name`, `section`, `descriptionHeading`, `description`, `room`, `courseState`, `ownerId`
        var updateMask: [String]

        func stringDictionaryEncoded() -> [String: String] {
            ["updateMask": updateMask.joined(separator: ",")]
        }
    }
}
