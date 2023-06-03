//
//  CoursePostsDataManager.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 15/5/23.
//

import Foundation
import GlassRoomAPI
import GlassRoomTypes
import Combine

class CoursePostsDataManager: ObservableObject {
    @Published private(set) var courseAnnouncements: [CourseAnnouncement] = []
    @Published private(set) var courseCourseWorks: [CourseWork] = []
    @Published private(set) var courseCourseMaterials: [CourseWorkMaterial] = []

    // used to determine if it should refresh or not
    @Published private(set) var lastRefreshDate: Date?

    var postData: [CoursePost] {
        self.courseAnnouncements.map({ .announcement($0) })
            .mergedWith(other: courseCourseWorks.map({ .courseWork($0) })) { lhs, rhs in
                lhs.id == rhs.id
            } isBefore: { lhs, rhs in
                lhs.updateDate > rhs.updateDate
            }
            .mergedWith(other: courseCourseMaterials.map({ .courseMaterial($0) })) { lhs, rhs in
                lhs.id == rhs.id
            } isBefore: { lhs, rhs in
                lhs.updateDate > rhs.updateDate
            }
    }

    var postDataIsEmpty: Bool {
        courseAnnouncements.isEmpty && courseCourseWorks.isEmpty && courseCourseMaterials.isEmpty
    }

    let courseId: String

    var loading: Bool {
        announcementsLoading || courseWorksLoading || courseMaterialsLoading
    }
    var hasNextPage: Bool {
        announcementsNextPageToken != nil || courseWorksNextPageToken != nil || courseMaterialsNextPageToken != nil
    }

    @Published private(set) var announcementsLoading: Bool = false
    @Published private(set) var courseWorksLoading: Bool = false
    @Published private(set) var courseMaterialsLoading: Bool = false

    @Published private(set) var announcementsNextPageToken: String?
    @Published private(set) var courseWorksNextPageToken: String?
    @Published private(set) var courseMaterialsNextPageToken: String?

    init(courseId: String) {
        self.courseId = courseId

        CoursePostsDataManager.loadedManagers[courseId] = self
    }

    func loadList(bypassCache: Bool = false, onlyCache: Bool = false) {
        announcementsLoading = true
        courseWorksLoading = true
        courseMaterialsLoading = true

        // use cache first either way to look faster
        let cachedAnnouncements = readAnnouncementsCache()
        let cachedCourseWorks = readCourseWorksCache()
        let cachedCourseMaterials = readCourseMaterialsCache()

        if !cachedAnnouncements.isEmpty { courseAnnouncements = cachedAnnouncements }
        if !cachedCourseWorks.isEmpty { courseCourseWorks = cachedCourseWorks }
        if !cachedCourseMaterials.isEmpty { courseCourseMaterials = cachedCourseMaterials }

        if bypassCache {
            refreshAnnouncementsList()
            refreshCourseWorksList()
            refreshCourseMaterialsList()
            lastRefreshDate = .now
        } else {
            // load from cache first, if that fails load from the list.
            if (cachedAnnouncements.isEmpty || lastRefreshDate == nil) && !onlyCache {
                refreshAnnouncementsList()
                lastRefreshDate = .now
            } else {
                self.courseAnnouncements = cachedAnnouncements
                announcementsLoading = false
            }
            if (cachedCourseWorks.isEmpty || lastRefreshDate == nil) && !onlyCache {
                refreshCourseWorksList()
                lastRefreshDate = .now
            } else {
                self.courseCourseWorks = cachedCourseWorks
                courseWorksLoading = false
            }
            if (cachedCourseMaterials.isEmpty || lastRefreshDate == nil) && !onlyCache {
                refreshCourseMaterialsList()
                lastRefreshDate = .now
            } else {
                self.courseCourseMaterials = cachedCourseMaterials
                courseMaterialsLoading = false
            }
        }
    }

    func refreshList(requestNextPageIfExists: Bool = false) {
        announcementsLoading = true
        courseWorksLoading = true
        courseMaterialsLoading = true

        refreshAnnouncementsList(requestNextPageIfExists: requestNextPageIfExists)
        refreshCourseWorksList(requestNextPageIfExists: requestNextPageIfExists)
        refreshCourseMaterialsList(requestNextPageIfExists: requestNextPageIfExists)
    }

    func clearCache(courseId: String) {
        FileSystem.write([CourseAnnouncement](), to: .announcements(courseId))
        FileSystem.write([CourseWork](), to: .courseWorks(courseId))
        FileSystem.write([CourseWorkMaterial](), to: .courseMaterials(courseId))
    }

    // MARK: Static functions
    static private(set) var loadedManagers: [String: CoursePostsDataManager] = [:]
    static private(set) var loadedManagersPublisher: CurrentValueSubject<[String: CoursePostsDataManager], Never> = .init([:])

    static func getManager(for courseId: String) -> CoursePostsDataManager {
        if let manager = loadedManagers[courseId] {
            return manager
        }
        let newInstance = CoursePostsDataManager(courseId: courseId)
        loadedManagers[courseId] = newInstance

        loadedManagersPublisher.send(loadedManagers)

        return newInstance
    }
}

// MARK: Per-type functions
extension CoursePostsDataManager {
    // MARK: Announcements
    func readAnnouncementsCache() -> [CourseAnnouncement] {
        // if the file exists in CourseCache
        if FileSystem.exists(file: .announcements(courseId)),
           let cacheItems = FileSystem.read([CourseAnnouncement].self, from: .announcements(courseId)) {
            return cacheItems
        }
        return []
    }

    func writeAnnouncementsCache() {
        FileSystem.write(courseAnnouncements, to: .announcements(courseId)) { error in
            Log.error("Error writing: \(error.localizedDescription)")
        }
    }

    func refreshAnnouncementsList(nextPageToken: String? = nil, requestNextPageIfExists: Bool = false) {
        GlassRoomAPI.GRCourses.GRAnnouncements.list(params: .init(courseId: courseId),
                                                    query: .init(announcementStates: nil,
                                                                 orderBy: nil,
                                                                 pageSize: nil,
                                                                 pageToken: nextPageToken),
                                                    data: VoidStringCodable()
        ) { response in
            switch response {
            case .success(let success):
                DispatchQueue.main.async {
                    self.courseAnnouncements.mergeWith(other: success.announcements,
                                                       isSame: { $0.id == $1.id },
                                                       isBefore: { $0.creationDate > $1.creationDate })
                }
                if let token = success.nextPageToken, !token.isEmpty, requestNextPageIfExists {
                    self.refreshAnnouncementsList(nextPageToken: token,
                                                  requestNextPageIfExists: requestNextPageIfExists)
                } else {
                    DispatchQueue.main.async {
                        self.announcementsNextPageToken = success.nextPageToken
                        self.announcementsLoading = false
                        self.writeAnnouncementsCache()
                    }
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.announcementsLoading = false
                }
            }
        }
    }

    // MARK: Course Works
    func readCourseWorksCache() -> [CourseWork] {
        // if the file exists in CourseCache
        if FileSystem.exists(file: .courseWorks(courseId)),
           let cacheItems = FileSystem.read([CourseWork].self, from: .courseWorks(courseId)) {
            return cacheItems
        }
        return []
    }

    func writeCourseWorksCache() {
        FileSystem.write(courseCourseWorks, to: .courseWorks(courseId)) { error in
            Log.error("Error writing: \(error.localizedDescription)")
        }
    }

    func refreshCourseWorksList(nextPageToken: String? = nil, requestNextPageIfExists: Bool = false) {
        GlassRoomAPI.GRCourses.GRCourseWork.list(params: .init(courseId: courseId),
                                                 query: .init(courseWorkStates: [.published],
                                                              orderBy: nil,
                                                              pageSize: nil,
                                                              pageToken: nextPageToken),
                                                 data: .init()
        ) { response in
            switch response {
            case .success(let success):
                DispatchQueue.main.async {
                    self.courseCourseWorks.mergeWith(other: success.courseWork,
                                                     isSame: { $0.id == $1.id },
                                                     isBefore: { $0.creationDate > $1.creationDate })
                }
                if let token = success.nextPageToken, !token.isEmpty, requestNextPageIfExists {
                    self.refreshCourseWorksList(nextPageToken: token, requestNextPageIfExists: requestNextPageIfExists)
                } else {
                    DispatchQueue.main.async {
                        self.courseWorksNextPageToken = success.nextPageToken
                        self.courseWorksLoading = false
                        self.writeCourseWorksCache()
                    }
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.courseWorksLoading = false
                }
            }
        }
    }

    // MARK: Course materials
    func readCourseMaterialsCache() -> [CourseWorkMaterial] {
        // if the file exists in CourseCache
        if FileSystem.exists(file: .courseMaterials(courseId)),
           let cacheItems = FileSystem.read([CourseWorkMaterial].self, from: .courseMaterials(courseId)) {
            return cacheItems
        }
        return []
    }

    func writeCourseMaterialsCache() {
        FileSystem.write(courseCourseMaterials, to: .courseMaterials(courseId)) { error in
            Log.error("Error writing: \(error.localizedDescription)")
        }
    }

    func refreshCourseMaterialsList(nextPageToken: String? = nil, requestNextPageIfExists: Bool = false) {
        GlassRoomAPI.GRCourses.GRCourseWorkMaterials.list(
            params: .init(courseId: courseId),
            query: .init(courseWorkMaterialStates: [.published],
                         orderBy: nil,
                         pageSize: nil,
                         pageToken: nil,
                         materialLink: nil,
                         materialDriveId: nil),
            data: .init()
        ) { response in
            switch response {
            case .success(let success):
                DispatchQueue.main.async {
                    self.courseCourseMaterials.mergeWith(other: success.courseWorkMaterial,
                                                         isSame: { $0.id == $1.id },
                                                         isBefore: { $0.creationDate > $1.creationDate })
                }
                if let token = success.nextPageToken, !token.isEmpty, requestNextPageIfExists {
                    self.refreshCourseMaterialsList(nextPageToken: token, requestNextPageIfExists: requestNextPageIfExists)
                } else {
                    DispatchQueue.main.async {
                        self.courseMaterialsNextPageToken = success.nextPageToken
                        self.courseMaterialsLoading = false
                        self.writeCourseMaterialsCache()
                    }
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self.courseMaterialsLoading = false
                }
            }
        }
    }
    
    func createNewAnnouncement(courseId: String,
                               id: String,
                               text: String,
                               materials: [AssignmentMaterial]?,
                               state: AnnouncementState,
                               alternateLink: String,
                               creationTime: String,
                               updateTime: String,
                               scheduledTime: String?,
                               assigneeMode: AssigneeMode?,
                               individualStudentsOptions: IndividualStudentsOptions?,
                               creatorUserId: String
    ) {
        let creationAndUpdateTime = Date().iso8601withFractionalSeconds
        let newAnnouncement = CourseAnnouncement(courseId: courseId,
                                                 id: id,
                                                 text: text,
                                                 materials: materials,
                                                 state: state,
                                                 alternateLink: alternateLink,
                                                 creationTime: creationAndUpdateTime,
                                                 updateTime: creationAndUpdateTime,
                                                 scheduledTime: scheduledTime,
                                                 assigneeMode: assigneeMode,
                                                 individualStudentsOptions: individualStudentsOptions,
                                                 creatorUserId: creatorUserId)
        
        GlassRoomAPI.GRCourses.GRAnnouncements.create(params: .init(courseId: courseId),
                                                   query: VoidStringCodable(),
                                                   data: newAnnouncement) { response in
            switch response {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func createNewCourseWork(courseId: String,
                             id: String,
                             title: String,
                             description: String?,
                             materials: [AssignmentMaterial]?,
                             state: CourseWorkState,
                             alternateLink: String,
                             creationTime: String,
                             updateTime: String,
                             dueDate: DueDate?,
                             dueTime: TimeOfDay?,
                             scheduledTime: String?,
                             maxPoints: Double?,
                             workType: CourseWorkType,
                             associatedWithDeveloper: Bool?,
                             assigneeMode: AssigneeMode?,
                             individualStudentsOptions: IndividualStudentsOptions?,
                             submissionModificationMode: SubmissionModificationMode?,
                             creatorUserId: String,
                             topicId: String?,
                             gradeCategory: GradeCategory?,
                             assignment: Assignment?,
                             multipleChoiceQuestion: MultipleChoiceQuestion?
    ) {
        let creationAndUpdateTime = Date().iso8601withFractionalSeconds
        let newCourseWork = CourseWork(courseId: courseId,
                                       id: id,
                                       title: title,
                                       description: description,
                                       materials: materials,
                                       state: state,
                                       alternateLink: alternateLink,
                                       creationTime: creationAndUpdateTime,
                                       updateTime: creationAndUpdateTime,
                                       dueDate: dueDate,
                                       dueTime: dueTime,
                                       scheduledTime: scheduledTime,
                                       maxPoints: maxPoints,
                                       workType: workType,
                                       associatedWithDeveloper: associatedWithDeveloper,
                                       assigneeMode: assigneeMode,
                                       individualStudentsOptions: individualStudentsOptions,
                                       submissionModificationMode: submissionModificationMode,
                                       creatorUserId: creatorUserId,
                                       topicId: topicId,
                                       gradeCategory: gradeCategory,
                                       assignment: assignment,
                                       multipleChoiceQuestion: multipleChoiceQuestion
        )
        
        GlassRoomAPI.GRCourses.GRCourseWork.create(params: .init(courseId: courseId),
                                                   query: VoidStringCodable(),
                                                   data: newCourseWork) { response in
            switch response {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func createNewCourseWorkMaterial(courseId: String,
                                     id: String,
                                     title: String,
                                     description: String?,
                                     materials: [AssignmentMaterial]?,
                                     state: CourseWorkMaterialState,
                                     alternateLink: String,
                                     creationTime: String,
                                     updateTime: String,
                                     scheduledTime: String?,
                                     assigneeMode: AssigneeMode?,
                                     individualStudentsOptions: IndividualStudentsOptions?,
                                     creatorUserId: String,
                                     topicId: String?
                                     
    ) {
        let creationAndUpdateTime = Date().iso8601withFractionalSeconds
        let newCourseWorkMaterial = CourseWorkMaterial(courseId: courseId,
                                                       id: id,
                                                       title: title,
                                                       description: description,
                                                       materials: materials,
                                                       state: state,
                                                       alternateLink: alternateLink,
                                                       creationTime: creationAndUpdateTime,
                                                       updateTime: creationAndUpdateTime,
                                                       scheduledTime: scheduledTime,
                                                       assigneeMode: assigneeMode,
                                                       individualStudentsOptions: individualStudentsOptions,
                                                       creatorUserId: creatorUserId,
                                                       topicId: topicId)
        
        GlassRoomAPI.GRCourses.GRCourseWorkMaterials.create(params: .init(courseId: courseId),
                                                   query: VoidStringCodable(),
                                                   data: newCourseWorkMaterial) { response in
            switch response {
            case .success(let success):
                print(success)
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
}
