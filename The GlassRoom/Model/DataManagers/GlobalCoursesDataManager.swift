//
//  GlobalCoursesDataManager.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 13/5/23.
//

import Foundation
import GlassRoomAPI

class GlobalCoursesDataManager: ObservableObject {
    @Published private(set) var courses: [Course]
    @Published private(set) var loading: Bool = false

    static var global: GlobalCoursesDataManager = .init()
    private init() {
        courses = []
    }

    func loadList(bypassCache: Bool = false) {
        loading = true
        if bypassCache {
            refreshList()
        } else {
            // load from cache first, if that fails load from the list.
            let cachedClasses = readCache()
            if cachedClasses.isEmpty {
                refreshList()
            } else {
                self.courses = cachedClasses
                loading = false
            }
        }
    }

    func clearCache() {
        FileSystem.write([Course](), to: "courseCache.json")
    }

    // MARK: Private methods

    /// Loads the courses, possibly recursively.
    ///
    /// - Parameters:
    ///   - nextPageToken: The token from the previous page for pagnation
    ///   - requestNextPageIfExists: If the API request returns a nextPageToken and this value is true, it will recursively call itself to load all pages.
    private func refreshList(nextPageToken: String? = nil, requestNextPageIfExists: Bool = true) {
        GlassRoomAPI.GRCourses.list(
            params: VoidStringCodable(),
            query: .init(studentId: nil,
                         teacherId: nil,
                         courseStates: nil,
                         pageSize: nil,
                         pageToken: nextPageToken),
            data: VoidStringCodable()
        ) { response in
            switch response {
            case .success(let success):
                self.courses.mergeWith(other: success.courses, isSame: { $0.id == $1.id }, isBefore: { $0.creationDate > $1.creationDate })
                if let token = success.nextPageToken, requestNextPageIfExists {
                    self.refreshList(nextPageToken: token, requestNextPageIfExists: requestNextPageIfExists)
                } else {
                    DispatchQueue.main.async {
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

    private func readCache() -> [Course] {
        // if the file exists in CourseCache
        if FileSystem.exists(file: "courseCache.json"),
           let cacheItems = FileSystem.read([Course].self, from: "courseCache.json") {
            return cacheItems
        }
        return []
    }

    private func writeCache() {
        FileSystem.write(courses, to: "courseCache.json") { error in
            print("Error writing: \(error.localizedDescription)")
        }
    }
}
