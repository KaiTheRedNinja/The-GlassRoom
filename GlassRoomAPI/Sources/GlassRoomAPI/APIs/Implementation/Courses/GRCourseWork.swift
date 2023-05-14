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
    public typealias CreatePathParameters = CourseIDPathParameters
    public typealias CreateQueryParameters = VoidStringCodable
    public typealias CreateRequestData = CourseWork
    public typealias CreateResponseData = CourseWork

    public static var apiCreatable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/courseWork"

    public typealias DeletePathParameters = CourseIDCourseWorkPathParameters
    public typealias DeleteQueryParameters = VoidStringCodable
    public typealias DeleteRequestData = VoidStringCodable
    public typealias DeleteResponseData = VoidStringCodable

    public static var apiDeletable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/courseWork/{id}"

    public typealias GetPathParameters = CourseIDCourseWorkPathParameters
    public typealias GetQueryParameters = VoidStringCodable
    public typealias GetRequestData = VoidStringCodable
    public typealias GetResponseData = CourseWork

    public static var apiGettable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/courseWork/{id}"

    public typealias ListPathParameters = CourseIDPathParameters
    public typealias ListQueryParameters = ListableQueryParameters
    public typealias ListRequestData = VoidStringCodable
    public typealias ListResponseData = ListableResponseData

    public static var apiListable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/courseWork"

    public typealias ModifyAssigneePathParameters = CourseIDCourseWorkPathParameters
    public typealias ModifyAssigneeQueryParameters = VoidStringCodable
    public typealias ModifyAssigneeRequestData = AssigneeModifiableRequestData
    public typealias ModifyAssigneeResponseData = CourseWork

    public static var apiAssigneeModifiable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/courseWork/{id}:modifyAssignees"

    public typealias PatchPathParameters = CourseIDCourseWorkPathParameters
    public typealias PatchQueryParameters = PatchableQueryParameters
    public typealias PatchRequestData = CourseWork
    public typealias PatchResponseData = CourseWork

    public static var apiPatchable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/courseWork/{id}"

    public struct CourseIDCourseWorkPathParameters: StringCodable {
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
        public var courseWorkStates: [CourseWorkState]?
        public var orderBy: String?
        public var pageSize: Int?
        public var pageToken: String?

        public init(courseWorkStates: [CourseWorkState]? = nil, orderBy: String? = nil, pageSize: Int? = nil, pageToken: String? = nil) {
            self.courseWorkStates = courseWorkStates
            self.orderBy = orderBy
            self.pageSize = pageSize
            self.pageToken = pageToken
        }

        public func stringDictionaryEncoded() -> [String: String] {
            var dict = [String: String]()
            if let courseWorkStates { dict["courseWorkStates"] = courseWorkStates.map({ $0.rawValue }).joined(separator: ",") } // TODO: Check this
            if let orderBy { dict["orderBy"] = orderBy }
            if let pageSize { dict["pageSize"] = pageSize.description }
            if let pageToken { dict["pageToken"] = pageToken }
            return dict
        }
    }

    public struct ListableResponseData: Codable {
        public var courseWork: [CourseWork]
        public var nextPageToken: String?

        public init(courseWork: [CourseWork], nextPageToken: String) {
            self.courseWork = courseWork
            self.nextPageToken = nextPageToken
        }
    }

    public struct AssigneeModifiableRequestData: Codable {
        public var assigneeMode: AssigneeMode
        public var modifyIndividualStudentsOptions: ModifyIndividualStudentsOptions

        public init(assigneeMode: AssigneeMode, modifyIndividualStudentsOptions: ModifyIndividualStudentsOptions) {
            self.assigneeMode = assigneeMode
            self.modifyIndividualStudentsOptions = modifyIndividualStudentsOptions
        }
    }

    public struct PatchableQueryParameters: StringCodable {
        /// Only the following are valid: `title`, `description`, `state`, `dueDate`, `dueTime`, `maxPoints`, `scheduledTime`, `submissionModificationMode`, `topicId`
        public var updateMask: [String]

        public init(updateMask: [String]) {
            self.updateMask = updateMask
        }

        public func stringDictionaryEncoded() -> [String: String] {
            ["updateMask": updateMask.joined(separator: ",")]
        }
    }
}
