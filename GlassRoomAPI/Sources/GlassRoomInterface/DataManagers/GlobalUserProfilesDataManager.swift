//
//  GlobalUserProfilesDataManager.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 19/5/23.
//

import Foundation
import GlassRoomAPI
import GlassRoomTypes

public class GlobalUserProfilesDataManager: ObservableObject {
    /// Maps the users to their courses
    @Published public private(set) var userProfiles: [UserProfile] {
        didSet {
            userProfilesMap = [:]
            for profile in userProfiles {
                userProfilesMap[profile.id] = profile
            }
        }
    }
    @Published public private(set) var students: [String: [StudentReference]] // the students for a course
    @Published public private(set) var teachers: [String: [TeacherReference]] // the teachers for a course

    // used to determine if it should refresh or not
    @Published public private(set) var lastRefreshDate: Date?

    public var loading: Bool {
        studentsLoading || teachersLoading
    }

    public var hasNextPage: Bool {
        studentsNextPageToken != nil || teachersNextPageToken != nil
    }

    @Published public private(set) var studentsLoading: Bool = false
    @Published public private(set) var teachersLoading: Bool = false

    @Published public private(set) var studentsNextPageToken: String?
    @Published public private(set) var teachersNextPageToken: String?

    public var userProfilesMap: [String: UserProfile] = [:]

    public static var global: GlobalUserProfilesDataManager = .init()
    private init() {
        userProfiles = []
        students = [:]
        teachers = [:]

        userProfiles = readProfilesCache()
    }

    // MARK: Loading
    public func loadList(for courseId: String, bypassCache: Bool = false, onlyCache: Bool = false) {
        studentsLoading = true
        teachersLoading = true

        // use cache first either way to look faster
        let cachedStudents = readStudentsCache(for: courseId)
        let cachedTeachers = readTeachersCache(for: courseId)

        if !cachedStudents.isEmpty { students[courseId] = cachedStudents }
        if !cachedTeachers.isEmpty { teachers[courseId] = cachedTeachers }

        if bypassCache {
            refreshStudentsList(courseId: courseId)
            refreshTeachersList(courseId: courseId)
            lastRefreshDate = .now
        } else {
            // load from cache first, if that fails load from the list.
            if (cachedStudents.isEmpty || lastRefreshDate == nil) && !onlyCache {
                refreshStudentsList(courseId: courseId)
                lastRefreshDate = .now
            } else {
                self.students[courseId] = cachedStudents
                studentsLoading = false
            }
            if (cachedTeachers.isEmpty || lastRefreshDate == nil) && !onlyCache {
                refreshTeachersList(courseId: courseId)
                lastRefreshDate = .now
            } else {
                self.teachers[courseId] = cachedTeachers
                teachersLoading = false
            }
        }
    }

    public func refreshList(for courseId: String, requestNextPageIfExists: Bool = false) {
        studentsLoading = true
        teachersLoading = true

        refreshStudentsList(courseId: courseId)
        refreshTeachersList(courseId: courseId)
    }

    func readStudentsCache(for courseId: String) -> [StudentReference] {
        // if the file exists in CourseCache
        if FileSystem.exists(file: .studentReferences(courseId)),
           let cacheItems = FileSystem.read([StudentReference].self, from: .studentReferences(courseId)) {
            return cacheItems
        }
        return []
    }

    func writeStudentsCache(for courseId: String) {
        FileSystem.write(students[courseId] ?? [], to: .studentReferences(courseId)) { error in
            Log.error("Error writing: \(error.localizedDescription)")
        }
        writeProfilesCache()
    }

    func refreshStudentsList(courseId: String) {
        GlassRoomAPI.GRCourses.GRStudents.list(
            params: .init(courseId: courseId),
            query: .init(pageSize: nil, pageToken: studentsNextPageToken),
            data: .init()
        ) { result in
            switch result {
            case .success(let success):
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
                    self.studentsNextPageToken = success.nextPageToken
                    self.studentsLoading = false
                    self.writeStudentsCache(for: courseId)
                }
            case .failure(let failure):
                Log.error("Failure :( \(failure.localizedDescription)")
            }
        }
    }

    func readTeachersCache(for courseId: String) -> [TeacherReference] {
        // if the file exists in CourseCache
        if FileSystem.exists(file: .teacherReferences(courseId)),
           let cacheItems = FileSystem.read([TeacherReference].self, from: .teacherReferences(courseId)) {
            return cacheItems
        }
        return []
    }

    func writeTeachersCache(for courseId: String) {
        FileSystem.write(teachers[courseId] ?? [], to: .teacherReferences(courseId)) { error in
            Log.error("Error writing: \(error.localizedDescription)")
        }
        writeProfilesCache()
    }

    func refreshTeachersList(courseId: String) {
        GlassRoomAPI.GRCourses.GRTeachers.list(
            params: .init(courseId: courseId),
            query: .init(pageSize: nil, pageToken: teachersNextPageToken),
            data: .init()
        ) { result in
            switch result {
            case .success(let success):
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
                    self.teachersNextPageToken = success.nextPageToken
                    self.teachersLoading = false
                    self.writeTeachersCache(for: courseId)
                }
            case .failure(let failure):
                Log.error("Failure :( \(failure.localizedDescription)")
            }
        }
    }

    func readProfilesCache() -> [UserProfile] {
        // if the file exists in CourseCache
        if FileSystem.exists(file: .userProfiles),
           let cacheItems = FileSystem.read([UserProfile].self, from: .userProfiles) {
            return cacheItems
        }
        return []
    }

    func writeProfilesCache() {
        FileSystem.write(userProfiles, to: .userProfiles) { error in
            Log.error("Error writing: \(error.localizedDescription)")
        }
    }

    // MARK: Types
    public struct StudentReference: Codable {
        public var courseId: String
        public var userId: String
        public var studentWorkFolder: DriveFolder?
    }

    public struct TeacherReference: Codable {
        public var courseId: String
        public var userId: String
    }
}
