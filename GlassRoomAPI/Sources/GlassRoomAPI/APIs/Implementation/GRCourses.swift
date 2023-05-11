//
//  GRCourses.swift
//  GlassRoomAPI
//
//  Created by Kai Quan Tay on 11/5/23.
//

extension GlassRoomAPI.GRCourses: GlassRoomCreatableDeletable, GlassRoomGettableListable, GlassRoomPatchable, GlassRoomUpdatable {
    typealias CreatePathParameters = Void
    typealias CreateRequestData = Void
    typealias CreateResponseData = Void

    /// Creates a course.
    ///
    /// The user specified in ownerId is the owner of the created course and added as a teacher. A non-admin requesting \
    /// user can only create a course with themselves as the owner. Domain admins can create courses owned by any \
    /// user within their domain.
    ///
    /// This method returns the following error codes:
    ///
    /// - `PERMISSION_DENIED` if the requesting user is not permitted to create courses or for access errors.
    /// - `NOT_FOUND` if the primary teacher is not a valid user.
    /// - `FAILED_PRECONDITION` if the course owner's account is disabled or for the following request errors:
    ///     - UserCannotOwnCourse
    ///     - UserGroupsMembershipLimitReached
    /// - `ALREADY_EXISTS` if an alias was specified in the id and already exists.
    ///
    /// ## HTTP request
    /// `POST https://classroom.googleapis.com/v1/courses`
    /// The URL uses gRPC Transcoding syntax.
    ///
    /// ## Request body
    /// The request body contains an instance of Course.
    ///
    /// ## Response body
    /// If successful, the response body contains a newly created instance of Course.
    static func create(params: Void, data: Void) -> Void? {
        return nil
    }

    typealias DeletePathParameters = Void
    typealias DeleteRequestData = Void
    typealias DeleteResponseData = Void

    /// Deletes a course.
    ///
    /// This method returns the following error codes:
    /// - `PERMISSION_DENIED` if the requesting user is not permitted to delete the requested course or for access errors.
    /// - `NOT_FOUND` if no course exists with the requested ID.
    ///
    /// ## HTTP request
    /// `DELETE https://classroom.googleapis.com/v1/courses/{id}`
    /// The URL uses gRPC Transcoding syntax.
    ///
    /// ## Path parameters
    /// `id: string` Identifier of the course to delete. This identifier can be either the Classroom-assigned identifier or an alias.
    ///
    /// ## Request body
    /// The request body must be empty.
    ///
    /// ## Response body
    /// If successful, the response body is empty.
    static func delete(params: Void, data: Void) -> Void? {
        return nil
    }

    typealias GetPathParameters = Void
    typealias GetRequestData = Void
    typealias GetResponseData = Void

    /// Returns a course.
    ///
    /// This method returns the following error codes:
    /// - `PERMISSION_DENIED` if the requesting user is not permitted to access the requested course or for access errors.
    /// - `NOT_FOUND` if no course exists with the requested ID.
    /// - `HTTP` request
    ///
    /// ## HTTP request
    /// `GET https://classroom.googleapis.com/v1/courses/{id}`
    /// The URL uses gRPC Transcoding syntax.
    ///
    /// ## Path parameters
    /// `id: string` Identifier of the course to return. This identifier can be either the Classroom-assigned identifier or an alias.
    ///
    /// ## Request body
    /// The request body must be empty.
    ///
    /// ## Response body
    /// If successful, the response body contains an instance of Course.
    static func get(params: Void, data: Void) -> Void? {
        return nil
    }

    typealias ListPathParameters = Void
    typealias ListRequestData = Void
    typealias ListResponseData = Void

    /// Returns a list of courses that the requesting user is permitted to view, restricted to those
    /// that match the request. Returned courses are ordered by creation time, with the most recently created coming first.
    ///
    /// This method returns the following error codes:
    /// - `PERMISSION_DENIED` for access errors.
    /// - `INVALID_ARGUMENT` if the query argument is malformed.
    /// - `NOT_FOUND` if any users specified in the query arguments do not exist.
    ///
    /// ## HTTP request
    /// `GET https://classroom.googleapis.com/v1/courses`
    /// The URL uses gRPC Transcoding syntax.
    ///
    /// ## Query parameters
    ///
    /// - `studentId: string` Restricts returned courses to those having a student with the specified identifier. The identifier can be one of the following:
    ///   - the numeric identifier for the user
    ///   - the email address of the user
    ///   - the string literal "me", indicating the requesting user
    /// - `teacherId: string` Restricts returned courses to those having a teacher with the specified identifier. The identifier can be one of the following:
    ///   - the numeric identifier for the user
    ///   - the email address of the user
    ///   - the string literal "me", indicating the requesting user
    /// - `courseStates[]: enum (CourseState)` Restricts returned courses to those in one of the specified states The default value is ACTIVE, ARCHIVED, PROVISIONED, DECLINED.
    /// - `pageSize: integer` Maximum number of items to return. Zero or unspecified indicates that the server may assign a maximum. The server may return fewer than the specified number of results.
    /// - `pageToken: string` nextPageToken value returned from a previous list call, indicating that the subsequent page of results should be returned. The
    /// list request must be otherwise identical to the one that resulted in this token.
    ///
    /// ## Request body
    /// The request body must be empty.
    ///
    /// ## Response body
    /// If successful, the response body contains data with the following structure:
    ///
    /// JSON representation
    ///
    /// ```
    /// {
    ///   courses": [
    ///     {
    ///       object (Course)
    ///     }
    ///   ],
    ///   nextPageToken": string
    /// }
    /// ```
    ///
    /// - `courses[]: object (Course)`  Courses that match the list request.
    /// - `nextPageToken: string` Token identifying the next page of results to return. If empty, no further results are available.
    ///
    static func list(params: Void, data: Void) -> Void? {
        return nil
    }

    typealias PatchPathParameters = Void
    typealias PatchRequestData = Void
    typealias PatchResponseData = Void

    /// Updates one or more fields in a course.
    ///
    /// This method returns the following error codes:
    /// - `PERMISSION_DENIED` if the requesting user is not permitted to modify the requested course or for access errors.
    /// - `NOT_FOUND` if no course exists with the requested ID.
    /// - `INVALID_ARGUMENT` if invalid fields are specified in the update mask or if no update mask is supplied.
    /// - `FAILED_PRECONDITION` for the following request errors:
    ///   - CourseNotModifiable
    ///   - InactiveCourseOwner
    ///   - IneligibleOwner
    ///
    /// ## HTTP request
    /// `PATCH https://classroom.googleapis.com/v1/courses/{id}`
    /// The URL uses gRPC Transcoding syntax.
    ///
    /// ## Path parameters
    /// `id: string` Identifier of the course to update. This identifier can be either the Classroom-assigned identifier or an alias.
    ///
    /// ## Query parameters
    /// `updateMask: string (FieldMask format)` Mask that identifies which fields on the course to update. This field is required to do an update.
    /// The update will fail if invalid fields are specified. The following fields are valid:
    ///   - `name`
    ///   - `section`
    ///   - `descriptionHeading`
    ///   - `description`
    ///   - `room`
    ///   - `courseState`
    ///   - `ownerId`
    /// Note: patches to ownerId are treated as being effective immediately, but in practice it may take some time for the ownership transfer of all affected resources to complete.
    ///
    /// When set in a query parameter, this field should be specified as `updateMask=<field1>,<field2>,...`
    /// This is a comma-separated list of fully qualified names of fields. Example: `user.displayName,photo`.
    ///
    /// ## Request body
    /// The request body contains an instance of Course.
    ///
    /// ## Response body
    /// If successful, the response body contains an instance of Course.
    static func patch(params: Void, data: Void) -> Void? {
        return nil
    }

    typealias UpdatePathParameters = Void
    typealias UpdateRequestData = Void
    typealias UpdateResponseData = Void

    /// Updates a course.
    ///
    /// This method returns the following error codes:
    /// - `PERMISSION_DENIED` if the requesting user is not permitted to modify the requested course or for access errors.
    /// - `NOT_FOUND` if no course exists with the requested ID.
    /// - `FAILED_PRECONDITION` for the following request errors:
    ///   - CourseNotModifiable
    ///
    /// ## HTTP request
    /// `PUT https://classroom.googleapis.com/v1/courses/{id}`
    /// The URL uses gRPC Transcoding syntax.
    ///
    /// ## Path parameters
    /// `id: string` Identifier of the course to update. This identifier can be either the Classroom-assigned identifier or an alias.
    ///
    /// ## Request body
    /// The request body contains an instance of Course.
    ///
    /// ## Response body
    /// If successful, the response body contains an instance of Course.
    static func update(params: Void, data: Void) -> Void? {
        return nil
    }
}
