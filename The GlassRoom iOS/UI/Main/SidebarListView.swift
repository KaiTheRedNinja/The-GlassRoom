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

    @State var searchQuery: String = ""

    var body: some View {
        List(selection: $selection) {
            if searchQuery.isEmpty {
                defaultListContent
            } else {
                ForEach(coursesForQuery(query: searchQuery)) { course in
                    sidebarCourseView(course: .course(course.id))
                }
            }
        }
        .navigationTitle(UIScreen.main.traitCollection.userInterfaceIdiom == .pad ? "Glassroom" : "")
        .listStyle(.insetGrouped)
        .searchable(text: $searchQuery)
        .onAppear {
            coursesManager.loadList()
        }
    }

    @ViewBuilder
    var defaultListContent: some View {
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

        if let archive = configuration.archive {
            Section {
                ForEach(archive.courses) { courseId in
                    sidebarCourseView(course: .course(courseId))
                }
            } header: {
                sidebarCourseView(course: .group(CourseGroup.archiveId))
            }
        }
    }

    func coursesForQuery(query: String) -> [Course] {
        let lowerQuery = query.lowercased()
        return coursesManager.courses.filter { course in
            configuration.nameFor(course.name).lowercased().contains(lowerQuery) &&
            !(configuration.archive?.courses.contains(course.id) ?? false)
        }
    }

    func sidebarCourseView(course: GeneralCourse) -> some View {
        SidebarCourseView(course: course)
            .contextMenu {
                switch course {
                case .course(let id):
                    Section("Group") {
                        let isArchived = configuration.archive?.courses.contains(id) ?? false
                        let isInGroup = configuration.courseGroups.contains(where: { $0.courses.contains(id) })
                        Button("\(isArchived ? "Unarchive and " : "")\(isInGroup ? "Move to" : "Create") new Group") {
                            // create new group
                            guard let course = coursesManager.courses.first(where: { $0.id == id }) else { return }

                            // remove the items from where they came from
                            configuration.archive?.courses.removeAll(where: { $0.id == id })
                            for index in 0..<configuration.courseGroups.count {
                                configuration.courseGroups[index].courses.removeAll(where: { $0.id == id })
                            }

                            // create new group
                            configuration.courseGroups.append(
                                .init(groupName: "Untitled Group",
                                      groupType: course.courseType,
                                      courses: [id])
                            )
                        }
                        Menu("\(isArchived ? "Unarchive and " : "")\(isInGroup ? "Move" : "Add") to Group") {
                            ForEach(configuration.courseGroups) { group in
                                Button(group.groupName) { // add to that group
                                    // remove the items from where they came from
                                    configuration.archive?.courses.removeAll(where: { $0.id == id })
                                    for index in 0..<configuration.courseGroups.count {
                                        configuration.courseGroups[index].courses.removeAll(where: { $0.id == id })
                                    }

                                    guard let destIndex = configuration.courseGroups.firstIndex(of: group) else { return }
                                    configuration.courseGroups[destIndex].courses.append(id)
                                }
                            }
                        }
                        if isInGroup {
                            Button("Remove from Group") { // remove from grp
                                configuration.archive?.courses.removeAll(where: { $0.id == id })
                                for index in 0..<configuration.courseGroups.count {
                                    configuration.courseGroups[index].courses.removeAll(where: { $0.id == id })
                                }
                            }
                        }
                    }
                    
                    Section("Archive") {
                        let isArchived = configuration.archive?.courses.contains(id) ?? false
                        Button("\(isArchived ? "Unarchive" : "Archive") Course") {
                            configuration.archive(item: course)
                        }
                    }
                case .group(let id):
                    if id != CourseGroup.archiveId {
                        Button("Archive Courses in Group") {
                            // add contents of group to that group
                            configuration.archive(item: course)
                        }
                        
                        Menu("Combine with Group") {
                            ForEach(configuration.courseGroups) { group in
                                Button(group.groupName) {
                                    // add contents of group to that group
                                    guard let sourceIndex = configuration.courseGroups.firstIndex(where: { $0.id == id }),
                                          let destIndex = configuration.courseGroups.firstIndex(of: group)
                                    else { return }
                                    configuration.courseGroups[destIndex].courses.append(
                                        contentsOf: configuration.courseGroups[sourceIndex].courses
                                    )
                                    configuration.courseGroups.removeAll(where: { $0.id == id })
                                }
                            }
                        }
                        
                        Divider()
                        
                        Button(role: .destructive) {
                            configuration.courseGroups.removeAll(where: { $0.id == id })
                        } label: {
                            Text("Delete Group")
                        }
                    }
                default:
                    EmptyView()
                }
            }
            .tag(course)
    }

    func viewForCourseType(type: Course.CourseType) -> some View {
        ForEach(coursesManager.courses) { course in
            if course.courseType == type, // correct type
               !(configuration.archive?.courses.contains(course.id) ?? false), // not archived
               !configuration.courseGroups.contains(where: { $0.courses.contains(course.id) }) { // not grouped
                sidebarCourseView(course: .course(course.id))
            }
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
