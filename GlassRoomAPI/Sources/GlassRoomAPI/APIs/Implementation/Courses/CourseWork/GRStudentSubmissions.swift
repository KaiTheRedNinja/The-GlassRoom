//
//  GRStudentSubmissions.swift
//  GlassRoomAPI
//
//  Created by Kai Quan Tay on 11/5/23.
//

import Foundation
import GlassRoomTypes

extension GlassRoomAPI.GRCourses.GRCourseWork.GRStudentSubmissions: GlassRoomGettableListable,
                                                                    GlassRoomAttachmentModifiable,
                                                                    GlassRoomPatchable,
                                                                    GlassRoomDeliverable {

    public typealias GetPathParameters = CourseIDCourseWorkSubmissionPathParameters
    public typealias GetQueryParameters = VoidStringCodable
    public typealias GetRequestData = VoidStringCodable
    public typealias GetResponseData = StudentSubmission

    public static var apiGettable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/courseWork/{courseWorkId}/studentSubmissions/{id}"

    public typealias ListPathParameters = CourseIDCourseWorkPathParameters
    public typealias ListQueryParameters = ListableQueryParameters
    public typealias ListRequestData = VoidStringCodable
    public typealias ListResponseData = ListableResponseData

    public static var apiListable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/courseWork/{courseWorkId}/studentSubmissions"

    public typealias ModifyAttachmentPathParameters = CourseIDCourseWorkSubmissionPathParameters
    public typealias ModifyAttachmentQueryParameters = VoidStringCodable
    public typealias ModifyAttachmentRequestData = ModifiableRequestData
    public typealias ModifyAttachmentResponseData = StudentSubmission

    public static var apiAttachmentModifiable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/courseWork/{courseWorkId}/studentSubmissions/{id}:modifyAttachments"

    public typealias PatchPathParameters = CourseIDCourseWorkSubmissionPathParameters
    public typealias PatchQueryParameters = PatchableQueryParameters
    public typealias PatchRequestData = StudentSubmission
    public typealias PatchResponseData = StudentSubmission

    public static var apiPatchable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/courseWork/{courseWorkId}/studentSubmissions/{id}"

    public typealias ReclaimPathParameters = CourseIDCourseWorkSubmissionPathParameters
    public typealias ReclaimQueryParameters = VoidStringCodable
    public typealias ReclaimRequestData = VoidStringCodable
    public typealias ReclaimResponseData = VoidStringCodable

    public static var apiReclaimable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/courseWork/{courseWorkId}/studentSubmissions/{id}:reclaim"

    public typealias ReturnPathParameters = CourseIDCourseWorkSubmissionPathParameters
    public typealias ReturnQueryParameters = VoidStringCodable
    public typealias ReturnRequestData = VoidStringCodable
    public typealias ReturnResponseData = VoidStringCodable

    public static var apiReturnable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/courseWork/{courseWorkId}/studentSubmissions/{id}:return"

    public typealias TurnInPathParameters = CourseIDCourseWorkSubmissionPathParameters
    public typealias TurnInQueryParameters = VoidStringCodable
    public typealias TurnInRequestData = VoidStringCodable
    public typealias TurnInResponseData = VoidStringCodable

    public static var apiSubmittable: String = "https://classroom.googleapis.com/v1/courses/{courseId}/courseWork/{courseWorkId}/studentSubmissions/{id}:turnIn"

    public struct CourseIDCourseWorkPathParameters: StringCodable {
        public var courseId: String
        public var courseWorkId: String

        public init(courseId: String, courseWorkId: String) {
            self.courseId = courseId
            self.courseWorkId = courseWorkId
        }

        public func stringDictionaryEncoded() -> [String: String] {
            [
                "courseId": courseId,
                "courseWorkId": courseWorkId
            ]
        }
    }

    public struct CourseIDCourseWorkSubmissionPathParameters: StringCodable {
        public var courseId: String
        public var courseWorkId: String
        public var id: String

        public init(courseId: String, courseWorkId: String, id: String) {
            self.courseId = courseId
            self.courseWorkId = courseWorkId
            self.id = id
        }

        public func stringDictionaryEncoded() -> [String: String] {
            [
                "courseId": courseId,
                "courseWorkId": courseWorkId,
                "id": id
            ]
        }
    }

    public struct ListableQueryParameters: StringCodable {
        public var userId: String?
        public var states: [SubmissionState]?
        public var late: [LateValues]?
        public var pageSize: Int?
        public var pageToken: String?

        public init(userId: String? = nil,
                    states: [SubmissionState]? = nil,
                    late: [LateValues]? = nil,
                    pageSize: Int? = nil,
                    pageToken: String? = nil) {
            self.userId = userId
            self.states = states
            self.late = late
            self.pageSize = pageSize
            self.pageToken = pageToken
        }

        public func stringDictionaryEncoded() -> [String: String] {
            var dict = [String: String]()
            if let userId { dict["userId"] = userId }
            if let states { dict["states"] = states.map({ $0.rawValue }).joined(separator: ",") }
            if let late { dict["late"] = late.map({ $0.rawValue }).joined(separator: ",") }
            if let pageSize { dict["pageSize"] = pageSize.description }
            if let pageToken { dict["pageToken"] = pageToken }
            return dict
        }
    }

    public struct ListableResponseData: Codable {
        public var studentSubmissions: [StudentSubmission]
        public var nextPageToken: String?

        public init(studentSubmissions: [StudentSubmission], nextPageToken: String) {
            self.studentSubmissions = studentSubmissions
            self.nextPageToken = nextPageToken
        }
    }

    public struct ModifiableRequestData: Codable {
        public var addAttachments: [Attachment]

        public init(addAttachments: [Attachment]) {
            self.addAttachments = addAttachments
        }
    }

    public struct PatchableQueryParameters: StringCodable {
        /// Only the following are valid: `draftGrade`, `assignedGrade`
        public var updateMask: [String]

        public init(updateMask: [String]) {
            self.updateMask = updateMask
        }

        public func stringDictionaryEncoded() -> [String: String] {
            ["updateMask": updateMask.joined(separator: ",")]
        }
    }
}
