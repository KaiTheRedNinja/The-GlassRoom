//
//  CenterSplitView.swift
//  The GlassRoom
//
//  Created by Kai Quan Tay on 13/5/23.
//

import SwiftUI
import GlassRoomInterface

struct CenterSplitView: View {
    @Binding var selectedCourse: GeneralCourse?
    @Binding var selectedPost: CoursePost?
    
    @State var coursePostsManager: CoursePostsDataManager?
    @SceneStorage("currentPage") var currentPage: CourseDisplayOption = .allPosts

    @StateObject var displayedCoursesManager: DisplayedCourseManager = .init()

    @ObservedObject var configuration = GlobalCoursesDataManager.global.configuration

    @AppStorage("tintToCourseColor") var tintToCourseColor: Bool = false
    @AppStorage("useFancyUI") var useFancyUI: Bool = false
    
    var body: some View {
        ZStack {
            content
        }
        #if os(macOS)
        .safeAreaInset(edge: .top) {
            if useFancyUI {
                CenterSplitViewToolbarTop(selectedCourse: $selectedCourse,
                                          currentPage: $currentPage,
                                          displayedCourseManager: displayedCoursesManager)
                .padding(3)
                .background {
                    Rectangle()
                        .fill(.ultraThinMaterial)
                }
                .cornerRadius(10)
                .shadow(color: .primary.opacity(0.2), radius: 4)
                .padding([.horizontal, .top], 10)
            } else {
                CenterSplitViewToolbarTop(selectedCourse: $selectedCourse,
                                          currentPage: $currentPage,
                                          displayedCourseManager: displayedCoursesManager)
                .overlay(alignment: .bottom) {
                    Divider()
                        .offset(y: 1)
                }
                .padding(.bottom, -8)
            }
        }
        #else
        .toolbar {
            ToolbarItem(placement: .principal) {
                Picker("", selection: $currentPage) {
                    Image(systemName: "list.bullet")
                        .tag(CourseDisplayOption.allPosts)
                    Image(systemName: "megaphone")
                        .tag(CourseDisplayOption.announcements)
                    Image(systemName: "square.and.pencil")
                        .tag(CourseDisplayOption.courseWork)
                    Image(systemName: "doc")
                        .tag(CourseDisplayOption.courseMaterial)
                    Image(systemName: "link")
                        .tag(CourseDisplayOption.resources)
                    Image(systemName: "person.2")
                        .tag(CourseDisplayOption.userRegister)
                }
                .pickerStyle(.segmented)
            }
        }
        #endif
        .onChange(of: selectedCourse) { _ in
            reloadAnnouncements()
        }
        .onAppear {
            reloadAnnouncements()
        }
    }

    @ViewBuilder
    var content: some View {
        if useFancyUI {
            ZStack {
                listContent
            }
            .background {
                Rectangle()
                    .fill(.ultraThinMaterial)
            }
            .cornerRadius(15)
            .shadow(color: .primary.opacity(0.2), radius: 4)
            .scrollIndicators(.never)
            .padding([.horizontal, .bottom], 10)
            .padding([.top], 5)
        } else {
            ZStack {
                listContent
            }
        }
    }

    @ViewBuilder
    var listContent: some View {
        Color.white.opacity(0.001) // prevent view from jumping around
        if let selectedCourse {
            if tintToCourseColor {
                configuration.colorFor(selectedCourse.id)
                    .opacity(0.1)
            }
            switch selectedCourse {
            case .course(_):
                if let coursePostsManager {
                    SingleCoursePostListView(selectedPost: $selectedPost,
                                             displayOption: $currentPage,
                                             posts: coursePostsManager,
                                             isInSearch: false)
                    .scrollContentBackground(.hidden)
                } else {
                    Text("Course post manager not found")
                }
            default:
                MultiCoursePostListView(selectedPost: $selectedPost,
                                        displayOption: $currentPage,
                                        displayedCourseIds: displayedCoursesManager)
                .scrollContentBackground(.hidden)
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
            let selectedCourseId = course
            let manager = CoursePostsDataManager.getManager(for: selectedCourseId)
            self.coursePostsManager = manager
            if manager.courseAnnouncements.isEmpty || manager.lastRefreshDate == nil {
                manager.loadList(bypassCache: true)
            }

            // if the class register is currently focused, reload it
            let profileManager = GlobalUserProfilesDataManager.global
            if currentPage == .userRegister,
               (profileManager.students[course]?.isEmpty ?? true) &&
               (profileManager.teachers[course]?.isEmpty ?? true) {
                profileManager.loadList(for: course)
            }

            // TODO: Intelligently refresh
        default: return
        }
    }

    enum CourseDisplayOption: String, CaseIterable {
        case allPosts = "All Posts"
        case announcements = "Announcements"
        case courseWork = "Courseworks"
        case courseMaterial = "Coursework Materials"
        case resources = "Resources"
        case userRegister = "Register"

        static var allCases: [CenterSplitView.CourseDisplayOption] = [
            .allPosts, .announcements, .courseWork, .courseMaterial, .resources, .userRegister
        ]
    }
}

struct CenterSplitView_Previews: PreviewProvider {
    static var previews: some View {
        CenterSplitView(selectedCourse: .constant(nil), selectedPost: .constant(nil))
    }
}

class DisplayedCourseManager: ObservableObject {
    @Published var displayedAggregateCourseIds: [String]

    init(displayedAggregateCourseIds: [String] = []) {
        self.displayedAggregateCourseIds = displayedAggregateCourseIds
    }
}
