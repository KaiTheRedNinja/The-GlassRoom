//
//  CourseWorkDataManager.swift
//  The GlassRoom
//
//  Created by Tristan on 13/05/2023.
//

import Foundation
@testable import GlassRoomAPI

class CourseAnnouncementsDataManager: ObservableObject {
    @Published private(set) var courseAnnouncements: [CourseAnnouncement]
    @Published private(set) var loading: Bool = false
    @Published private(set) var nextPageToken: String?

    let courseId: String

    init(courseId: String) {
        self.courseAnnouncements = []
        self.courseId = courseId

        CourseAnnouncementsDataManager.loadedManagers[courseId] = self
    }

    func loadList(bypassCache: Bool = false) {
        loading = true
        if bypassCache {
            // use cache first anyway
            let cachedAnnouncements = readCache()
            if !cachedAnnouncements.isEmpty {
                courseAnnouncements = cachedAnnouncements
            }
            refreshList()
        } else {
            // load from cache first, if that fails load from the list.
            let cachedAnnouncements = readCache()
            if cachedAnnouncements.isEmpty {
                refreshList()
            } else {
                self.courseAnnouncements = cachedAnnouncements
                loading = false
            }
        }
    }

    func clearCache(courseId: String) {
        FileSystem.write([CourseAnnouncement](), to: "\(courseId)_courseAnnouncements.json")
    }

    /// Loads the courses, possibly recursively.
    ///
    /// - Parameters:
    ///   - nextPageToken: The token from the previous page for pagnation
    ///   - requestNextPageIfExists: If the API request returns a nextPageToken and this value is true, it will recursively call itself to load all pages.
    func refreshList(nextPageToken: String? = nil, requestNextPageIfExists: Bool = false) {
        GlassRoomAPI.GRCourses.GRAnnouncements.list(params: .init(courseId: courseId),
                                                    query: .init(announcementStates: nil,
                                                                 orderBy: nil,
                                                                 pageSize: nil,
                                                                 pageToken: nil),
                                                    data: VoidStringCodable()
        ) { response in
            switch response {
            case .success(let success):
                self.courseAnnouncements.mergeWith(other: success.announcements,
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
    private func readCache() -> [CourseAnnouncement] {
        // if the file exists in CourseCache
        if FileSystem.exists(file: "\(courseId)_courseAnnouncements.json"),
           let cacheItems = FileSystem.read([CourseAnnouncement].self, from: "\(courseId)_courseAnnouncements.json") {
            return cacheItems
        }
        return []
    }

    private func writeCache() {
        FileSystem.write(courseAnnouncements, to: "\(courseId)_courseAnnouncements.json") { error in
            print("Error writing: \(error.localizedDescription)")
        }
    }

    // MARK: Static functions
    static private(set) var loadedManagers: [String: CourseAnnouncementsDataManager] = [:]

    static func getManager(for courseId: String) -> CourseAnnouncementsDataManager {
        if let manager = loadedManagers[courseId] {
            return manager
        }
        return .init(courseId: courseId)
    }
}
