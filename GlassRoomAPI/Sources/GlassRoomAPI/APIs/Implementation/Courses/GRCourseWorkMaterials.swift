//
//  GRCourseWorkMaterials.swift
//  GlassRoomAPI
//
//  Created by Kai Quan Tay on 11/5/23.
//

import GlassRoomTypes

extension GlassRoomAPI.GRCourses.GRCourseWorkMaterials: GlassRoomCreatableDeletable,
                                                        GlassRoomGettableListable,
                                                        GlassRoomPatchable {

    public typealias CreatePathParameters = CourseIDPathParameters
    public typealias CreateQueryParameters = VoidStringCodable
    public typealias CreateRequestData = CourseWorkMaterial
    public typealias CreateResponseData = CourseWorkMaterial

    public static var apiCreatable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/courseWorkMaterials/{id}"

    public typealias DeletePathParameters = CourseIDCourseWorkMaterialsPathParameters
    public typealias DeleteQueryParameters = VoidStringCodable
    public typealias DeleteRequestData = VoidStringCodable
    public typealias DeleteResponseData = VoidStringCodable

    public static var apiDeletable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/courseWorkMaterials/{id}"

    public typealias GetPathParameters = CourseIDCourseWorkMaterialsPathParameters
    public typealias GetQueryParameters = VoidStringCodable
    public typealias GetRequestData = VoidStringCodable
    public typealias GetResponseData = CourseWorkMaterial

    public static var apiGettable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/courseWorkMaterials/{id}"

    public typealias ListPathParameters = CourseIDPathParameters
    public typealias ListQueryParameters = ListableQueryParameters
    public typealias ListRequestData = VoidStringCodable
    public typealias ListResponseData = ListableResponseData

    public static var apiListable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/courseWorkMaterials"

    public typealias PatchPathParameters = CourseIDCourseWorkMaterialsPathParameters
    public typealias PatchQueryParameters = PatchableQueryParameters
    public typealias PatchRequestData = CourseWorkMaterial
    public typealias PatchResponseData = CourseWorkMaterial

    public static var apiPatchable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/courseWorkMaterials/{id}"

    public struct CourseIDCourseWorkMaterialsPathParameters: StringCodable {
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
        public var courseWorkMaterialStates: [CourseWorkMaterialState]?
        public var orderBy: String?
        public var pageSize: Int?
        public var pageToken: String?
        public var materialLink: String?
        public var materialDriveId: String?

        public init(courseWorkMaterialStates: [CourseWorkMaterialState]? = nil,
                    orderBy: String? = nil,
                    pageSize: Int? = nil,
                    pageToken: String? = nil,
                    materialLink: String? = nil,
                    materialDriveId: String? = nil) {
            self.courseWorkMaterialStates = courseWorkMaterialStates
            self.orderBy = orderBy
            self.pageSize = pageSize
            self.pageToken = pageToken
            self.materialLink = materialLink
            self.materialDriveId = materialDriveId
        }

        public func stringDictionaryEncoded() -> [String: String] {
            var dict = [String: String]()
            if let courseWorkMaterialStates { dict["courseWorkMaterialStates"] = courseWorkMaterialStates.map({ $0.rawValue }).joined(separator: ",") }
            if let orderBy { dict["orderBy"] = orderBy }
            if let pageSize { dict["pageSize"] = pageSize.description }
            if let pageToken { dict["pageToken"] = pageToken }
            if let materialLink { dict["materialLink"] = materialLink }
            if let materialDriveId { dict["materialDriveId"] = materialDriveId }
            return dict
        }
    }

    public struct ListableResponseData: Codable {
        public var courseWorkMaterial: [CourseWorkMaterial]
        public var nextPageToken: String?

        public init(courseWorkMaterial: [CourseWorkMaterial], nextPageToken: String) {
            self.courseWorkMaterial = courseWorkMaterial
            self.nextPageToken = nextPageToken
        }
    }

    public struct PatchableQueryParameters: StringCodable {
        /// Only the following are valid: `title`, `description`, `state`, `scheduledTime`, `topicId`
        public var updateMask: [String]

        public init(updateMask: [String]) {
            self.updateMask = updateMask
        }

        public func stringDictionaryEncoded() -> [String: String] {
            ["updateMask": updateMask.joined(separator: ",")]
        }
    }
}
