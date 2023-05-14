//
//  CenterSplitView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 13/5/23.
//

import SwiftUI
import GlassRoomAPI

struct CenterSplitView: View {
    @Binding var selectedCourse: GeneralCourse?
    @Binding var selectedPost: CoursePost?
    
    @State var courseAnnouncementManager: CourseAnnouncementsDataManager?
    @State var courseCourseWorksManager: CourseCourseWorksDataManager?
    
    @State var currentPage: CourseDisplayOption = .allPosts
    
    var body: some View {
        ZStack {
            if selectedCourse != nil {
                MultiCoursePostListView(selectedPost: $selectedPost,
                                        announcements: .init(array: announcementManagers),
                                        courseWorks: .init(array: courseWorkManagers))
            } else {
                ZStack {
                    Text("No Course Selected")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                        .minimumScaleFactor(0.1)
                        .lineLimit(1)
                }
                .frame(maxHeight: .infinity)
            }
        }
        .safeAreaInset(edge: .top) {
            CenterSplitViewToolbarTop(currentPage: $currentPage)
        }
        .onChange(of: selectedCourse) { _ in
            reloadAnnouncements()
        }
        .onAppear {
            reloadAnnouncements()
        }
    }
    
    var notImplementedYet: some View {
        ZStack {
            Text("Not Implemented Yet")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
                .padding(.horizontal)
                .minimumScaleFactor(0.1)
                .lineLimit(1)
        }
        .frame(maxHeight: .infinity)
    }
    
    func reloadAnnouncements() {
        guard let selectedCourse else { return }
        switch selectedCourse {
        case .course(let course):
            let selectedCourseId = course.id
            let announcementManager = CourseAnnouncementsDataManager.getManager(for: selectedCourseId)
            self.courseAnnouncementManager = announcementManager
            if announcementManager.courseAnnouncements.isEmpty {
                announcementManager.loadList(bypassCache: true)
            }
            let courseWorkManager = CourseCourseWorksDataManager.getManager(for: selectedCourseId)
            self.courseCourseWorksManager = courseWorkManager
            if courseWorkManager.courseWorks.isEmpty {
                courseWorkManager.loadList(bypassCache: true)
            }
            
            // TODO: Intelligently refresh
        default: return
        }
    }
    
    var announcementManagers: [CourseAnnouncementsDataManager] {
        guard let selectedCourse else { return [] }
        switch selectedCourse {
        case .course(_):
            let announcementManagers = courseAnnouncementManager != nil ? [courseAnnouncementManager!] : []
            if currentPage != .courseWork { // if its announcements or all, show announcements.
                return announcementManagers
            } else {
                return []
            }
        case .allTeaching, .allEnrolled:
            let courseType = selectedCourse == .allTeaching ? Course.CourseType.teaching : .enrolled
            let courses = GlobalCoursesDataManager.global.courses
            return Array(CourseAnnouncementsDataManager.loadedManagers.values).filter { manager in
                let item = courses.first(where: { $0.id == manager.courseId })
                return item?.courseType == courseType
            }
        }
    }
    
    var courseWorkManagers: [CourseCourseWorksDataManager] {
        guard let selectedCourse else { return [] }
        switch selectedCourse {
        case .course(_):
            let courseWorkManagers = courseCourseWorksManager != nil ? [courseCourseWorksManager!] : []
            if currentPage != .courseWork { // if its announcements or all, show announcements.
                return courseWorkManagers
            } else {
                return []
            }
        case .allTeaching, .allEnrolled:
            let courseType = selectedCourse == .allTeaching ? Course.CourseType.teaching : .enrolled
            let courses = GlobalCoursesDataManager.global.courses
            return Array(CourseCourseWorksDataManager.loadedManagers.values).filter { manager in
                let item = courses.first(where: { $0.id == manager.courseId })
                return item?.courseType == courseType
            }
        }
    }

    enum CourseDisplayOption: String, CaseIterable {
        case allPosts = "All Posts"
        case announcements = "Announcements"
        case courseWork = "Course Works"
    }
}

struct CenterSplitView_Previews: PreviewProvider {
    static var previews: some View {
        CenterSplitView(selectedCourse: .constant(nil), selectedPost: .constant(nil))
    }
}
