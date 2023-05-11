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
        enum GRAliases: GlassRoomAPIProtocol {}
        enum GRAnnouncements: GlassRoomAPIProtocol {}
        enum GRCourseWork: GlassRoomAPIProtocol {
            enum GRStudentSubmissions: GlassRoomAPIProtocol {}
        }
        enum GRCourseWorkMaterials: GlassRoomAPIProtocol {}
        enum GRStudents: GlassRoomAPIProtocol {}
        enum GRTeachers: GlassRoomAPIProtocol {}
        enum GRTopics: GlassRoomAPIProtocol {}
    }
    enum GRInvitations: GlassRoomAPIProtocol {}
    enum GRRegistrations: GlassRoomAPIProtocol {}
    enum GRUserProfiles: GlassRoomAPIProtocol {
        enum GRGuardianInvitations: GlassRoomAPIProtocol {}
        enum GRGuardians: GlassRoomAPIProtocol {}
    }
}
