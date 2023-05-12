//
//  GRAnnouncements.swift
//  GlassRoomAPI
//
//  Created by Kai Quan Tay on 11/5/23.
//

extension GlassRoomAPI.GRCourses.GRAnnouncements: GlassRoomCreatableDeletable,
                                                  GlassRoomGettableListable,
                                                  GlassRoomAssigneeModifiable,
                                                  GlassRoomPatchable {
    typealias CreatePathParameters = CourseIDPathParameters
    typealias CreateQueryParameters = VoidStringCodable
    typealias CreateRequestData = CourseAnnouncement
    typealias CreateResponseData = CourseAnnouncement

    static var apiCreatable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/announcements"

    typealias DeletePathParameters = CourseIDAnnouncementPathParameters
    typealias DeleteQueryParameters = VoidStringCodable
    typealias DeleteRequestData = VoidStringCodable
    typealias DeleteResponseData = VoidStringCodable

    static var apiDeletable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/announcements/{id}"

    typealias GetPathParameters = CourseIDAnnouncementPathParameters
    typealias GetQueryParameters = VoidStringCodable
    typealias GetRequestData = VoidStringCodable
    typealias GetResponseData = CourseAnnouncement

    static var apiGettable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/announcements/{id}"

    typealias ListPathParameters = CourseIDPathParameters
    typealias ListQueryParameters = ListableQueryParameters
    typealias ListRequestData = VoidStringCodable
    typealias ListResponseData = ListableResponseData

    static var apiListable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/announcements/"

    typealias ModifyAssigneePathParameters = CourseIDAnnouncementPathParameters
    typealias ModifyAssigneeQueryParameters = VoidStringCodable
    typealias ModifyAssigneeRequestData = AssigneeModifiableRequestData
    typealias ModifyAssigneeResponseData = CourseAnnouncement

    static var apiAssigneeModifiable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/announcements/{id}:modifyAssignees"

    typealias PatchPathParameters = CourseIDAnnouncementPathParameters
    typealias PatchQueryParameters = PatchableQueryParameters
    typealias PatchRequestData = CourseAnnouncement
    typealias PatchResponseData = CourseAnnouncement

    static var apiPatchable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/announcements/{id}"

    struct CourseIDAnnouncementPathParameters: StringCodable {
        var courseId: String
        var id: String

        func stringDictionaryEncoded() -> [String: String] {
            [
                "courseId": courseId,
                "id": id
            ]
        }
    }

    struct ListableQueryParameters: StringCodable {
        var announcementStates: [AnnouncementState]?
        var orderBy: String?
        var pageSize: Int?
        var pageToken: String?

        func stringDictionaryEncoded() -> [String: String] {
            var dict = [String: String]()
            if let announcementStates { dict["announcementStates"] = announcementStates.description } // TODO: Check this
            if let orderBy { dict["orderBy"] = orderBy }
            if let pageSize { dict["pageSize"] = pageSize.description }
            if let pageToken { dict["pageToken"] = pageToken }
            return dict
        }
    }

    struct ListableResponseData: Codable {
        var announcements: [CourseAnnouncement]
        var nextPageToken: String
    }

    struct AssigneeModifiableRequestData: Codable {
        var assigneeMode: AssigneeMode
        var modifyIndividualStudentsOptions: ModifyIndividualStudentsOptions
    }

    struct PatchableQueryParameters: StringCodable {
        /// Only the following are valid: `text`, `state`, `scheduledTime`
        var updateMask: [String]

        func stringDictionaryEncoded() -> [String: String] {
            ["updateMask": updateMask.joined(separator: ",")]
        }
    }
}
