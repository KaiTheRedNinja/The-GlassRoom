//
//  GlobalCourseWorkDataManager.swift
//  The GlassRoom
//
//  Created by Tristan on 13/05/2023.
//

import Foundation
@testable import GlassRoomAPI

class GlobalCourseAnnouncementsDataManager: ObservableObject {
    @Published private(set) var courseAnnouncements: [CourseAnnouncement]
    @Published var loading: Bool = false

    static var global: GlobalCourseAnnouncementsDataManager = .init()
    private init() {
        courseAnnouncements = []
    }

    func loadList(courseId: String, bypassCache: Bool = false) {
        loading = true
        if bypassCache {
            refreshList(courseId: courseId)
        } else {
            // load from cache first, if that fails load from the list.
            let cachedClasses = readCache(courseId: courseId)
            if cachedClasses.isEmpty {
                refreshList(courseId: courseId)
            } else {
                self.courseAnnouncements = cachedClasses
                loading = false
            }
        }
    }

    func clearCache(courseId: String) {
        FileSystem.write([CourseAnnouncement](), to: "\(courseId)_courseAnnouncements.json")
    }

    // MARK: Private methods

    /// Loads the courses, possibly recursively.
    ///
    /// - Parameters:
    ///   - nextPageToken: The token from the previous page for pagnation
    ///   - requestNextPageIfExists: If the API request returns a nextPageToken and this value is true, it will recursively call itself to load all pages.
    private func refreshList(courseId: String, nextPageToken: String? = nil, requestNextPageIfExists: Bool = false) {
        GlassRoomAPI.GRCourses.GRAnnouncements.list(params: .init(courseId: courseId),
                                                    query: .init(announcementStates: nil,
                                                                 orderBy: nil,
                                                                 pageSize: nil,
                                                                 pageToken: nil),
                                                    data: VoidStringCodable()
        ) { response in
            switch response {
            case .success(let success):
                if let token = success.nextPageToken, requestNextPageIfExists {
                    self.refreshList(courseId: courseId, nextPageToken: token, requestNextPageIfExists: requestNextPageIfExists)
                } else {
                    DispatchQueue.main.async {
                        self.loading = false
                        self.courseAnnouncements = success.announcements
                        self.writeCache(courseId: courseId)
                    }
                }
            case .failure(let failure):
                print("Failure: \(failure.localizedDescription)")
            }
        }
    }

    private func readCache(courseId: String) -> [CourseAnnouncement] {
        // if the file exists in CourseCache
        if FileSystem.exists(file: "\(courseId)_courseAnnouncements.json"),
           let cacheItems = FileSystem.read([CourseAnnouncement].self, from: "\(courseId)_courseAnnouncements.json") {
            return cacheItems
        }
        return []
    }

    private func writeCache(courseId: String) {
        FileSystem.write(courseAnnouncements, to: "\(courseId)_courseAnnouncements.json") { error in
            print("Error writing: \(error.localizedDescription)")
        }
    }
}
