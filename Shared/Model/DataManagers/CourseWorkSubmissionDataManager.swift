//
//  CourseWorkSubmissionDataManager.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 15/5/23.
//

import Foundation
import GlassRoomAPI
import GlassRoomTypes

class CourseWorkSubmissionDataManager: ObservableObject {
    @Published private(set) var submissions: [StudentSubmission] = []
    @Published private(set) var loading: Bool = false
    @Published private(set) var nextPageToken: String?

    let courseId: String
    let courseWorkId: String

    init(courseId: String, courseWorkId: String) {
        self.courseId = courseId
        self.courseWorkId = courseWorkId

        if var existingManagers = CourseWorkSubmissionDataManager.loadedManagers[courseId] {
            existingManagers[courseWorkId] = self
            CourseWorkSubmissionDataManager.loadedManagers[courseId] = existingManagers
        } else {
            CourseWorkSubmissionDataManager.loadedManagers[courseId] = [courseWorkId: self]
        }
    }

    func loadList(bypassCache: Bool = false) {
        loading = true
        let cachedSubmissions = readCache()
        if !cachedSubmissions.isEmpty {
            submissions = cachedSubmissions
        }
        
        if bypassCache {
            refreshList()
        } else {
            // load from cache first, if that fails load from the list.
            if cachedSubmissions.isEmpty {
                refreshList()
            } else {
                loading = false
            }
        }
    }

    func clearCache() {
        FileSystem.write([StudentSubmission](), to: .submissions(courseId, courseWorkId))
    }

    func readCache() -> [StudentSubmission] {
        // if the file exists in CourseCache
        if FileSystem.exists(file: .submissions(courseId, courseWorkId)),
           let cacheItems = FileSystem.read([StudentSubmission].self, from: .submissions(courseId, courseWorkId)) {
            return cacheItems
        }
        return []
    }

    func writeCache() {
        FileSystem.write(submissions, to: .submissions(courseId, courseWorkId)) { error in
            Log.error("Error writing: \(error.localizedDescription)")
        }
    }

    func refreshList(nextPageToken: String? = nil, requestNextPageIfExists: Bool = false) {
        self.loading = true
        GlassRoomAPI.GRCourses.GRCourseWork.GRStudentSubmissions.list(
            params: .init(courseId: courseId, courseWorkId: courseWorkId),
            query: .init(userId: nil,
                         states: nil,
                         late: nil,
                         pageSize: nil,
                         pageToken: nextPageToken),
            data: .init()
        ) { response in
            switch response {
            case .success(let success):
                DispatchQueue.main.async {
                    self.submissions.mergeWith(other: success.studentSubmissions,
                                                       isSame: { $0.id == $1.id },
                                                       isBefore: { $0.creationDate > $1.creationDate })
                }
                if let token = success.nextPageToken, !token.isEmpty, requestNextPageIfExists {
                    self.refreshList(nextPageToken: token,
                                     requestNextPageIfExists: requestNextPageIfExists)
                } else {
                    DispatchQueue.main.async {
                        self.nextPageToken = success.nextPageToken
                        self.loading = false
                        self.writeCache()
                    }
                }
            case .failure(let failure):
                Log.error("Failure: \(failure.localizedDescription)")
                DispatchQueue.main.async {
                    self.loading = false
                }
            }
        }
    }

    // MARK: Static functions
    static private(set) var loadedManagers: [String: [String: CourseWorkSubmissionDataManager]] = [:]

    static func getManager(for courseId: String, courseWorkId: String) -> CourseWorkSubmissionDataManager {
        if let courseManagers = loadedManagers[courseId],
           let manager = courseManagers[courseWorkId] {
            return manager
        }
        let newInstance = CourseWorkSubmissionDataManager(courseId: courseId, courseWorkId: courseWorkId)
        if loadedManagers[courseId] != nil {
            loadedManagers[courseId]?[courseWorkId] = newInstance
        } else {
            loadedManagers[courseId] = [courseWorkId: newInstance]
        }
        return newInstance
    }
}
