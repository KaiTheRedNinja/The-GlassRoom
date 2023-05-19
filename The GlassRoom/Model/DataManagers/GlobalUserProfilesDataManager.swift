//
//  GlobalUserProfilesDataManager.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 19/5/23.
//

import Foundation
import GlassRoomAPI
import GlassRoomTypes

class GlobalUserProfilesDataManager: ObservableObject {
    /// Maps the users to their courses
    @Published private(set) var userProfiles: [UserProfile] {
        didSet {
            userProfilesMap = [:]
            for profile in userProfiles {
                userProfilesMap[profile.id] = profile
            }
        }
    }
    @Published private(set) var students: [String: [StudentReference]] // the students for a course
    @Published private(set) var teachers: [String: [TeacherReference]] // the teachers for a course

    var userProfilesMap: [String: UserProfile] = [:]

    static var global: GlobalUserProfilesDataManager = .init()
    private init() {
        userProfiles = []
        students = [:]
        teachers = [:]
    }

    // MARK: Loading
    func loadProfiles(for courseId: String) {
        GlassRoomAPI.GRCourses.GRStudents.list(
            params: .init(courseId: courseId),
            query: .init(pageSize: nil, pageToken: nil),
            data: .init()) { result in
                switch result {
                case .success(let success):
                    Log.info("Success! \(success.students)")
                case .failure(let failure):
                    Log.error("Failure :( \(failure.localizedDescription)")
                }
            }
    }

    // MARK: Types
    struct StudentReference: Codable {
        public var courseId: String
        public var userId: String
        public var studentWorkFolder: DriveFolder
    }

    struct TeacherReference: Codable {
        public var courseId: String
        public var userId: String
    }
}
