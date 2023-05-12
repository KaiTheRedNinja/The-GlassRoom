//
//  GlassRoomAPI.swift
//  GlassRoomAPI
//
//  Created by Kai Quan Tay on 11/5/23.
//

import Foundation

// Definitions of all the APIs. They're implemented in other files.
enum GlassRoomAPI {
    /**Requires `https://www.googleapis.com/auth/classroom.courses` scope**/
    enum GRCourses: GlassRoomAPIProtocol {
        /**No additional scopes**/
        enum GRAliases: GlassRoomAPIProtocol {}
        /**Requires `https://www.googleapis.com/auth/classroom.announcements` scope**/
        enum GRAnnouncements: GlassRoomAPIProtocol {}
        /**Requires `https://www.googleapis.com/auth/classroom.coursework.students` scope**/
        enum GRCourseWork: GlassRoomAPIProtocol {
            /**Requires `https://www.googleapis.com/auth/classroom.coursework.students` scope**/
            @available(macOS, unavailable, message: "Not implemented yet")
            enum GRStudentSubmissions: GlassRoomAPIProtocol {}
        }
        /**Requires `https://www.googleapis.com/auth/classroom.courseworkmaterials` scope**/
        enum GRCourseWorkMaterials: GlassRoomAPIProtocol {}
        /**Requires `https://www.googleapis.com/auth/classroom.rosters` scope**/
        enum GRStudents: GlassRoomAPIProtocol {}
        /**Requires `https://www.googleapis.com/auth/classroom.rosters` scope**/
        enum GRTeachers: GlassRoomAPIProtocol {}
        /**Requires `https://www.googleapis.com/auth/classroom.topics` scope**/
        enum GRTopics: GlassRoomAPIProtocol {}
    }
    /**Requires `https://www.googleapis.com/auth/classroom.rosters` scope**/
    enum GRInvitations: GlassRoomAPIProtocol {}
    /**Requires `https://www.googleapis.com/auth/classroom.rosters` scope**/
    enum GRUserProfiles: GlassRoomAPIProtocol {

    // MARK: Unfinished APIs
        /**Requires `https://www.googleapis.com/auth/classroom.guardianlinks.students` scope**/
        @available(macOS, unavailable, message: "Not implemented yet")
        enum GRGuardianInvitations: GlassRoomAPIProtocol {}
        /**Requires `https://www.googleapis.com/auth/classroom.guardianlinks.students` scope**/
        @available(macOS, unavailable, message: "Not implemented yet")
        enum GRGuardians: GlassRoomAPIProtocol {}
    }

    /**Requires `https://www.googleapis.com/auth/classroom.push-notifications` scope**/
    @available(macOS, unavailable, message: "Not implemented yet")
    enum GRRegistrations: GlassRoomAPIProtocol {}
}

struct VoidStringCodable: StringCodable, Codable {
    func stringDictionaryEncoded() -> [String : String] { [:] }
}

// Required scopes:
// https://www.googleapis.com/auth/classroom.courses
// https://www.googleapis.com/auth/classroom.announcements
// https://www.googleapis.com/auth/classroom.coursework.students
// https://www.googleapis.com/auth/classroom.courseworkmaterials
// https://www.googleapis.com/auth/classroom.rosters
// https://www.googleapis.com/auth/classroom.topics
