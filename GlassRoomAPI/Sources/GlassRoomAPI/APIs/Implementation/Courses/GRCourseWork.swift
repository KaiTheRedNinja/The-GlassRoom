//
//  GRCourseWork.swift
//  GlassRoomAPI
//
//  Created by Kai Quan Tay on 11/5/23.
//

extension GlassRoomAPI.GRCourses.GRCourseWork: GlassRoomCreatableDeletable,
                                               GlassRoomGettableListable,
                                               GlassRoomAssigneeModifiable,
                                               GlassRoomPatchable {
    typealias CreatePathParameters = CourseIDPathParameters
    typealias CreateQueryParameters = VoidStringCodable
    typealias CreateRequestData = CourseWork
    typealias CreateResponseData = CourseWork

    static var apiCreatable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/courseWork"

    typealias DeletePathParameters = CourseIDCourseWorkPathParameters
    typealias DeleteQueryParameters = VoidStringCodable
    typealias DeleteRequestData = VoidStringCodable
    typealias DeleteResponseData = VoidStringCodable

    static var apiDeletable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/courseWork/{id}"

    typealias GetPathParameters = CourseIDCourseWorkPathParameters
    typealias GetQueryParameters = VoidStringCodable
    typealias GetRequestData = VoidStringCodable
    typealias GetResponseData = CourseWork

    static var apiGettable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/courseWork/{id}"

    typealias ListPathParameters = CourseIDPathParameters
    typealias ListQueryParameters = ListableQueryParameters
    typealias ListRequestData = VoidStringCodable
    typealias ListResponseData = ListableResponseData

    static var apiListable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/courseWork"

    typealias ModifyAssigneePathParameters = CourseIDCourseWorkPathParameters
    typealias ModifyAssigneeQueryParameters = VoidStringCodable
    typealias ModifyAssigneeRequestData = AssigneeModifiableRequestData
    typealias ModifyAssigneeResponseData = CourseWork

    static var apiAssigneeModifiable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/courseWork/{id}:modifyAssignees"

    typealias PatchPathParameters = CourseIDCourseWorkPathParameters
    typealias PatchQueryParameters = PatchableQueryParameters
    typealias PatchRequestData = CourseWork
    typealias PatchResponseData = CourseWork

    static var apiPatchable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/courseWork/{id}"

    struct CourseIDCourseWorkPathParameters: StringCodable {
        var courseId: String
        var id: String

        func stringDictionaryEncoded() -> [String: String] {
            [
                "courseID": courseId,
                "id": id
            ]
        }
    }

    struct ListableQueryParameters: StringCodable {
        var courseWorkStates: [CourseWorkState]?
        var orderBy: String?
        var pageSize: Int?
        var pageToken: String?

        func stringDictionaryEncoded() -> [String: String] {
            var dict = [String: String]()
            if let courseWorkStates { dict["courseWorkStates"] = courseWorkStates.description } // TODO: Check this
            if let orderBy { dict["orderBy"] = orderBy }
            if let pageSize { dict["pageSize"] = pageSize.description }
            if let pageToken { dict["pageToken"] = pageToken }
            return dict
        }
    }

    struct ListableResponseData: Codable {
        var courseWork: [CourseWork]
        var nextPageToken: String
    }

    struct AssigneeModifiableRequestData: Codable {
        var assigneeMode: AssigneeMode
        var modifyIndividualStudentsOptions: ModifyIndividualStudentsOptions
    }

    struct PatchableQueryParameters: StringCodable {
        /// Only the following are valid: `title`, `description`, `state`, `dueDate`, `dueTime`, `maxPoints`, `scheduledTime`, `submissionModificationMode`, `topicId`
        var updateMask: [String]

        func stringDictionaryEncoded() -> [String: String] {
            ["updateMask": updateMask.joined(separator: ",")]
        }
    }
}
