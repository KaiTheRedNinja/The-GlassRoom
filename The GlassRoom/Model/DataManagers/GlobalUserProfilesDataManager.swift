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
            data: .init()
        ) { result in
            switch result {
            case .success(let success):
                Log.info("Success! \(success.students.count)")
                // save the data
                var newProfiles: [UserProfile] = []
                var newStudents: [StudentReference] = []
                for student in success.students {
                    newProfiles.append(student.profile)
                    newStudents.append(.init(courseId: student.courseId,
                                             userId: student.userId,
                                             studentWorkFolder: student.studentWorkFolder))
                }
                DispatchQueue.main.async {
                    self.userProfiles.mergeWith(other: newProfiles,
                                                isSame: { $0.id == $1.id },
                                                isBefore: { $0.name.fullName < $1.name.fullName })
                    if self.students[courseId] != nil {
                        self.students[courseId]?.mergeWith(other: newStudents,
                                                           isSame: { $0.userId == $1.userId },
                                                           isBefore: { $0.userId < $1.userId })
                    } else {
                        self.students[courseId] = newStudents
                    }
                }
            case .failure(let failure):
                Log.error("Failure :( \(failure.localizedDescription)")
            }
        }
        GlassRoomAPI.GRCourses.GRTeachers.list(
            params: .init(courseId: courseId),
            query: .init(pageSize: nil, pageToken: nil),
            data: .init()
        ) { result in
            switch result {
            case .success(let success):
                Log.info("Success! \(success.teachers.count)")
                // save the data
                var newProfiles: [UserProfile] = []
                var newTeachers: [TeacherReference] = []
                for teacher in success.teachers {
                    newProfiles.append(teacher.profile)
                    newTeachers.append(.init(courseId: teacher.courseId,
                                             userId: teacher.userId))
                }
                DispatchQueue.main.async {
                    self.userProfiles.mergeWith(other: newProfiles,
                                                isSame: { $0.id == $1.id },
                                                isBefore: { $0.name.fullName < $1.name.fullName })
                    if self.teachers[courseId] != nil {
                        self.teachers[courseId]?.mergeWith(other: newTeachers,
                                                           isSame: { $0.userId == $1.userId },
                                                           isBefore: { $0.userId < $1.userId })
                    } else {
                        self.teachers[courseId] = newTeachers
                    }
                }
            case .failure(let failure):
                Log.error("Failure :( \(failure.localizedDescription)")
            }
        }
    }

    // MARK: Types
    struct StudentReference: Codable {
        public var courseId: String
        public var userId: String
        public var studentWorkFolder: DriveFolder?
    }

    struct TeacherReference: Codable {
        public var courseId: String
        public var userId: String
    }
}
