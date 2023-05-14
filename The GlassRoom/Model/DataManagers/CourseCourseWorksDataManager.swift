//
//  CourseCourseWorksDataManager.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 14/5/23.
//

import Foundation
import GlassRoomAPI

class CourseCourseWorksDataManager: ObservableObject {
    @Published private(set) var courseWorks: [CourseWork]
    @Published private(set) var loading: Bool = false
    @Published private(set) var nextPageToken: String?

    let courseId: String

    init(courseId: String) {
        self.courseWorks = []
        self.courseId = courseId

        CourseCourseWorksDataManager.loadedManagers[courseId] = self
    }

    func loadList(bypassCache: Bool = false) {
        loading = true
        if bypassCache {
            // use cache first anyway
            let cachedWorks = readCache()
            if !cachedWorks.isEmpty {
                courseWorks = cachedWorks
            }
            refreshList()
        } else {
            // load from cache first, if that fails load from the list.
            let cachedWorks = readCache()
            if cachedWorks.isEmpty {
                refreshList()
            } else {
                self.courseWorks = cachedWorks
                loading = false
            }
        }
    }

    func clearCache(courseId: String) {
        FileSystem.write([CourseWork](), to: "\(courseId)_courseWorks.json")
    }

    /// Loads the courses, possibly recursively.
    ///
    /// - Parameters:
    ///   - nextPageToken: The token from the previous page for pagnation
    ///   - requestNextPageIfExists: If the API request returns a nextPageToken and this value is true, it will recursively call itself to load all pages.
    func refreshList(nextPageToken: String? = nil, requestNextPageIfExists: Bool = false) {
        GlassRoomAPI.GRCourses.GRCourseWork.list(params: .init(courseId: courseId),
                                                 query: .init(courseWorkStates: [.published],
                                                              orderBy: nil,
                                                              pageSize: nil,
                                                              pageToken: nextPageToken),
                                                 data: .init()
        ) { response in
            switch response {
            case .success(let success):
                print("Success: \(success)")
                self.courseWorks.mergeWith(other: success.courseWork,
                                           isSame: { $0.id == $1.id },
                                           isBefore: { $0.creationDate > $1.creationDate })
                if let token = success.nextPageToken, requestNextPageIfExists {
                    self.refreshList(nextPageToken: token, requestNextPageIfExists: requestNextPageIfExists)
                } else {
                    DispatchQueue.main.async {
                        self.nextPageToken = success.nextPageToken
                        self.loading = false
                        self.writeCache()
                    }
                }
            case .failure(let failure):
                print("Failure: \(failure.localizedDescription)")
                self.loading = false
            }
        }
    }

    // MARK: Private methods
    private func readCache() -> [CourseWork] {
        // if the file exists in CourseCache
        if FileSystem.exists(file: "\(courseId)_courseWorks.json"),
           let cacheItems = FileSystem.read([CourseWork].self, from: "\(courseId)_courseWorks.json") {
            return cacheItems
        }
        return []
    }

    private func writeCache() {
        FileSystem.write(courseWorks, to: "\(courseId)_courseWorks.json") { error in
            print("Error writing: \(error.localizedDescription)")
        }
    }

    // MARK: Static functions
    static private(set) var loadedManagers: [String: CourseCourseWorksDataManager] = [:]

    static func getManager(for courseId: String) -> CourseCourseWorksDataManager {
        if let manager = loadedManagers[courseId] {
            return manager
        }
        return .init(courseId: courseId)
    }
}
