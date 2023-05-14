//
//  CenterSplitView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 13/5/23.
//

import SwiftUI
import GlassRoomAPI

struct CenterSplitView: View {
    @Binding var selectedCourse: Course?
    @Binding var selectedPost: CoursePost?

    @State var courseAnnouncementManager: CourseAnnouncementsDataManager?
    @State var courseCourseWorksManager: CourseCourseWorksDataManager?

    @State var currentPage: CourseDisplayOption = .announcements

    var body: some View {
        ZStack {
            if selectedCourse != nil {
                switch currentPage {
                case .announcements:
                    if let courseAnnouncementManager {
                        CourseAnnouncementsContentsListView(selectedPost: $selectedPost,
                                                            courseAnnouncementsManager: courseAnnouncementManager)
                    } else {
                        notImplementedYet
                    }
                case .courseWork:
                    if let courseCourseWorksManager {
                        CourseCourseWorksContentsListView(selectedPost: $selectedPost,
                                                          courseWorksManager: courseCourseWorksManager)
                    } else {
                        notImplementedYet
                    }
                case .allPosts:
                    if let courseAnnouncementManager, let courseCourseWorksManager {
                        CoursePostContentsListView(selectedPost: $selectedPost,
                                                   courseAnnouncementsManager: courseAnnouncementManager,
                                                   courseWorksManager: courseCourseWorksManager)
                    } else {
                        notImplementedYet
                    }
                }
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
            HStack(alignment: .center) {
                SegmentedControl(.init(get: {
                    switch currentPage {
                    case .announcements: return 0
                    case .courseWork: return 1
                    case .allPosts: return 2
                    }
                }, set: { newValue in
                    currentPage = .allCases[newValue]
                }), options: CourseDisplayOption.allCases.map({ $0.rawValue }))
            }
            .padding(.horizontal, 5)
            .frame(height: 25)
            .frame(maxWidth: .infinity)
            .background(.thinMaterial)
            .overlay(alignment: .bottom) {
                Divider()
                    .offset(y: 1)
            }
            .padding(.bottom, -7)
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
        guard let selectedCourseId = selectedCourse?.id else {
            self.courseAnnouncementManager = nil
            return
        }
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
    }

    enum CourseDisplayOption: String, CaseIterable {
        case announcements = "Announcements"
        case courseWork = "Course Works"
        case allPosts = "All Posts"
    }
}

struct CenterSplitView_Previews: PreviewProvider {
    static var previews: some View {
        CenterSplitView(selectedCourse: .constant(nil), selectedPost: .constant(nil))
    }
}
