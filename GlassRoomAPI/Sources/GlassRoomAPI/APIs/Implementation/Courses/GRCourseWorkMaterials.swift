//
//  GRCourseWorkMaterials.swift
//  GlassRoomAPI
//
//  Created by Kai Quan Tay on 11/5/23.
//

extension GlassRoomAPI.GRCourses.GRCourseWorkMaterials: GlassRoomCreatableDeletable,
                                                        GlassRoomGettableListable,
                                                        GlassRoomPatchable {

    typealias CreatePathParameters = CourseIDPathParameters
    typealias CreateQueryParameters = VoidStringCodable
    typealias CreateRequestData = CourseWorkMaterial
    typealias CreateResponseData = CourseWorkMaterial

    static var apiCreatable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/courseWorkMaterials/{id}"

    typealias DeletePathParameters = CourseIDCourseWorkMaterialsPathParameters
    typealias DeleteQueryParameters = VoidStringCodable
    typealias DeleteRequestData = VoidStringCodable
    typealias DeleteResponseData = VoidStringCodable

    static var apiDeletable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/courseWorkMaterials/{id}"

    typealias GetPathParameters = CourseIDCourseWorkMaterialsPathParameters
    typealias GetQueryParameters = VoidStringCodable
    typealias GetRequestData = VoidStringCodable
    typealias GetResponseData = CourseWorkMaterial

    static var apiGettable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/courseWorkMaterials/{id}"

    typealias ListPathParameters = CourseIDPathParameters
    typealias ListQueryParameters = ListableQueryParameters
    typealias ListRequestData = VoidStringCodable
    typealias ListResponseData = ListableResponseData

    static var apiListable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/courseWorkMaterials"

    typealias PatchPathParameters = CourseIDCourseWorkMaterialsPathParameters
    typealias PatchQueryParameters = PatchableQueryParameters
    typealias PatchRequestData = CourseWorkMaterial
    typealias PatchResponseData = CourseWorkMaterial

    static var apiPatchable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/courseWorkMaterials/{id}"

    struct CourseIDCourseWorkMaterialsPathParameters: StringCodable {
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
        var courseWorkMaterialStates: [CourseWorkMaterialState]?
        var orderBy: String?
        var pageSize: Int?
        var pageToken: String?
        var materialLink: String?
        var materialDriveId: String?

        func stringDictionaryEncoded() -> [String: String] {
            var dict = [String: String]()
            if let courseWorkMaterialStates { dict["courseWorkMaterialStates"] = courseWorkMaterialStates.description } // TODO: Check this
            if let orderBy { dict["orderBy"] = orderBy }
            if let pageSize { dict["pageSize"] = pageSize.description }
            if let pageToken { dict["pageToken"] = pageToken }
            if let materialLink { dict["materialLink"] = materialLink }
            if let materialDriveId { dict["materialDriveId"] = materialDriveId }
            return dict
        }
    }

    struct ListableResponseData: Codable {
        var courseWorkMaterial: [CourseWorkMaterial]
        var nextPageToken: String
    }

    struct PatchableQueryParameters: StringCodable {
        /// Only the following are valid: `title`, `description`, `state`, `scheduledTime`, `topicId`
        var updateMask: [String]

        func stringDictionaryEncoded() -> [String: String] {
            ["updateMask": updateMask.joined(separator: ",")]
        }
    }
}
