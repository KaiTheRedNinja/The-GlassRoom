//
//  GlassRoomAPI.swift
//  GlassRoomAPI
//
//  Created by Kai Quan Tay on 11/5/23.
//

import Foundation

// Definitions of all the APIs. They're implemented in other files.
public enum GlassRoomAPI {
    /**Requires `https://www.googleapis.com/auth/classroom.courses` scope**/
    public enum GRCourses: GlassRoomAPIProtocol {
        /**No additional scopes**/
        public enum GRAliases: GlassRoomAPIProtocol {}
        /**Requires `https://www.googleapis.com/auth/classroom.announcements` scope**/
        public enum GRAnnouncements: GlassRoomAPIProtocol {}
        /**Requires `https://www.googleapis.com/auth/classroom.coursework.students` scope**/
        public enum GRCourseWork: GlassRoomAPIProtocol {
            /**Requires `https://www.googleapis.com/auth/classroom.coursework.students` scope**/
            @available(macOS, unavailable, message: "Not implemented yet")
            public enum GRStudentSubmissions: GlassRoomAPIProtocol {}
        }
        /**Requires `https://www.googleapis.com/auth/classroom.courseworkmaterials` scope**/
        public enum GRCourseWorkMaterials: GlassRoomAPIProtocol {}
        /**Requires `https://www.googleapis.com/auth/classroom.rosters` scope**/
        public enum GRStudents: GlassRoomAPIProtocol {}
        /**Requires `https://www.googleapis.com/auth/classroom.rosters` scope**/
        public enum GRTeachers: GlassRoomAPIProtocol {}
        /**Requires `https://www.googleapis.com/auth/classroom.topics` scope**/
        public enum GRTopics: GlassRoomAPIProtocol {}
    }
    /**Requires `https://www.googleapis.com/auth/classroom.rosters` scope**/
    public enum GRInvitations: GlassRoomAPIProtocol {}
    /**Requires `https://www.googleapis.com/auth/classroom.rosters` scope**/
    public enum GRUserProfiles: GlassRoomAPIProtocol {

    // MARK: Unfinished APIs
        /**Requires `https://www.googleapis.com/auth/classroom.guardianlinks.students` scope**/
        @available(macOS, unavailable, message: "Not implemented yet")
        public enum GRGuardianInvitations: GlassRoomAPIProtocol {}
        /**Requires `https://www.googleapis.com/auth/classroom.guardianlinks.students` scope**/
        @available(macOS, unavailable, message: "Not implemented yet")
        public enum GRGuardians: GlassRoomAPIProtocol {}
    }

    /**Requires `https://www.googleapis.com/auth/classroom.push-notifications` scope**/
    @available(macOS, unavailable, message: "Not implemented yet")
    public enum GRRegistrations: GlassRoomAPIProtocol {}
}

public struct VoidStringCodable: StringCodable, Codable {
    public func stringDictionaryEncoded() -> [String : String] { [:] }
}

// Required scopes:
// https://www.googleapis.com/auth/classroom.courses
// https://www.googleapis.com/auth/classroom.announcements
// https://www.googleapis.com/auth/classroom.coursework.students
// https://www.googleapis.com/auth/classroom.courseworkmaterials
// https://www.googleapis.com/auth/classroom.rosters
// https://www.googleapis.com/auth/classroom.topics
