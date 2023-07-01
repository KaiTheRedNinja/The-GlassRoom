//
//  SidebarListView.swift
//  The GlassRoom iOS
//
//  Created by Kai Quan Tay on 1/7/23.
//

import SwiftUI
import GlassRoomTypes

struct SidebarListView: View {
    @Binding var selection: GeneralCourse?
    @ObservedObject var coursesManager: GlobalCoursesDataManager = .global
    @ObservedObject var configuration = GlobalCoursesDataManager.CoursesConfiguration.loadedFromFileSystem()

    var body: some View {
        List(selection: $selection) {
            Section {
                groupsForCourseType(type: .teaching)
                viewForCourseType(type: .teaching)
            } header: {
                sidebarCourseView(course: .allTeaching)
            }
            Section {
                groupsForCourseType(type: .enrolled)
                viewForCourseType(type: .enrolled)
            } header: {
                sidebarCourseView(course: .allEnrolled)
            }
        }
        .navigationTitle(UIScreen.main.traitCollection.userInterfaceIdiom == .pad ? "Glassroom" : "")
        .listStyle(.insetGrouped)
        .onAppear {
            coursesManager.loadList()
        }
    }

    func sidebarCourseView(course: GeneralCourse) -> some View {
        SidebarCourseView(course: course)
            .contextMenu {
                switch course {
                case .course(_):
                    Section("Group") {
                        Button("New group") {
                            // create new group
                        }
                        Menu("Add to group") {
                            ForEach(configuration.courseGroups) { group in
                                Button(group.groupName) {
                                    // add to that group
                                }
                            }
                        }
                    }
                    // if its in a group
                    // Button("Remove from group") {}
                    Button("Archive Course") {}
                    // Button("Unarchive") {}
                case .group(_):
                    Button("Archive Group") {}
                default:
                    EmptyView()
                }
            }
            .tag(course)
    }

    func viewForCourseType(type: Course.CourseType) -> some View {
        ForEach(coursesManager.courses.filter({ $0.courseType == type })) { course in
            sidebarCourseView(course: .course(course.id))
        }
    }

    func groupsForCourseType(type: Course.CourseType) -> some View {
        ForEach(configuration.courseGroups.filter({ $0.groupType == type })) { group in
            DisclosureGroup {
                ForEach(group.courses) { courseId in
                    sidebarCourseView(course: .course(courseId))
                }
            } label: {
                sidebarCourseView(course: .group(group.id))
            }
        }
    }
}
