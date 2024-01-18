//
//  GlobalCoursesDataManager.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 13/5/23.
//

import Foundation
import GlassRoomAPI
import GlassRoomTypes

public class GlobalCoursesDataManager: ObservableObject {
    @Published public private(set) var courses: [Course] {
        didSet {
            courseIdMap = [:]
            for course in courses {
                courseIdMap[course.id] = course
            }
        }
    }
    @Published public private(set) var loading: Bool = false
    @Published public private(set) var preArchivedCourses = []

    @Published public var courseIdMap: [String: Course] = [:]

    public static var global: GlobalCoursesDataManager = .init()
    private init() {
        courses = []
    }

    public func loadList(bypassCache: Bool = false) {
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

    public func clearCache() {
        FileSystem.write([Course](), to: .courses)
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
                            DispatchQueue.main.async {
                                
                                for course in success.courses {
                                    if [course.courseState] == [.archived] {
                                        CoursesConfiguration.global.archive(item: .course(course.id))
                                        CoursesConfiguration.global.saveToFileSystem()
                                    }
                                }

                                self.courses.mergeWith(other: success.courses,
                                                       isSame: { $0.id == $1.id },
                                                       isBefore: { $0.creationDate > $1.creationDate })
                            }
                            if let token = success.nextPageToken, requestNextPageIfExists {
                                self.refreshList(nextPageToken: token, requestNextPageIfExists: requestNextPageIfExists)
                            } else {
                                DispatchQueue.main.async {
                                    self.loading = false
                                    self.writeCache()
                                    
                                }
                                if let token = success.nextPageToken, requestNextPageIfExists {
                                    self.refreshList(nextPageToken: token, requestNextPageIfExists: requestNextPageIfExists)
                                } else {
                                    DispatchQueue.main.async {
                                        self.loading = false
                                        self.writeCache()
                                    }
                                }
                            }
            case .failure(_):
                DispatchQueue.main.async {
                    self.loading = false
                }
            }
        }
    }
    private func readCache() -> [Course] {
        // if the file exists in CourseCache
        if FileSystem.exists(file: .courses),
           let cacheItems = FileSystem.read([Course].self, from: .courses) {
            return cacheItems
        }
        return []
    }

    private func writeCache() {
        FileSystem.write(courses, to: .courses) { error in
            Log.error("Error writing: \(error.localizedDescription)")
        }
    }
}
